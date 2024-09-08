/*

4) Procedimientos. 
TSQL

*/


--Procedure 1:
/*Escribir un procedimiento almacenado que dado un tipo de riesgo ('Bajo','Medio','Alto'), 
muestre los datos de las violaciones (violCodigo, violDescrip) para dicho tipo, no devolver datos repetidos.*/
GO
CREATE PROCEDURE ObtenerViolacionesPorRiesgo
    @TipoRiesgo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT tv.violCodigo, tv.violDescrip
    FROM TipoViolacion tv
    JOIN Inspecciones insp ON tv.violCodigo = insp.violCodigo
    WHERE insp.inspRiesgo = @TipoRiesgo;
END;

GO

EXEC ObtenerViolacionesPorRiesgo @TipoRiesgo = 'Bajo';

GO



--Procedure 2: 
/*Mediante una función que reciba un código de violación, devolver cuantos 
establecimientos con licencia vencida y nunca renovada tuvieron dicha violación.*/
CREATE FUNCTION ContarEstablecimientosConLicenciaVencida (
    @CodigoViolacion INT
)
RETURNS INT
AS
BEGIN
    DECLARE @ConteoEstablecimientos INT;

    SELECT @ConteoEstablecimientos = COUNT(DISTINCT estNumero)
    FROM Establecimientos
    WHERE estNumero IN (
        SELECT estNumero
        FROM Licencias
        WHERE DATEDIFF(day, GETDATE(), licFchVto) < 0
        AND estNumero NOT IN (
            SELECT estNumero
            FROM Licencias
            WHERE licStatus = 'APR'
            )
        )
    AND estNumero IN (
        SELECT estNumero
        FROM Inspecciones
        WHERE violCodigo = @CodigoViolacion
    );

    RETURN @ConteoEstablecimientos;
END;

GO

DECLARE @CodigoViolacion INT = (SELECT v.violCodigo FROM TipoViolacion v WHERE v.violDescrip = 'Falta de capacitación');
SELECT dbo.ContarEstablecimientosConLicenciaVencida(@CodigoViolacion);

GO

/*PRECARGA DE PRUEBA:

INSERT INTO Establecimientos (estNombre, estDireccion, estTelefono, estLatitud, estLongitud) 
VALUES ('Pancho Viene', 'Salinas, Canelones', '+233453789', 41.6138, -72.2010);

DECLARE @IdEst21 INT;
SELECT @IdEst21 = estNumero
FROM Establecimientos
WHERE estNombre = 'Pancho Viene';

DECLARE @IdTP10 INT;
SELECT @IdTP10 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Falta de capacitación';

INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2024-05-15 09:00:00', 120), @IdEst21, 'Alto', 'Falla', @IdTP10, 'Falta capacitacion.');

INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst21, '2024-05-15', '2024-06-01', 'REV');
*/


--Procedure 3: 
/*Escribir un procedimiento almacenado que dado un rango de fechas, retorne por parámetros de salida 
la cantidad de inspecciones que tuvieron un resultado 'Oficina no encontrada' y la cantidad de inspecciones que no tienen comentarios.*/
CREATE PROCEDURE ObtenerInspeccionesPorRangoFecha
    @FechaInicio DATE,
    @FechaFin DATE,
    @CantidadOficinaNoEncontrada INT OUTPUT,
    @CantidadSinComentarios INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @CantidadOficinaNoEncontrada = COUNT(CASE WHEN insp.inspResultado = 'Oficina no encontrada' THEN 1 END),
           @CantidadSinComentarios = COUNT(CASE WHEN insp.inspComents IS NULL OR insp.inspComents = '' THEN 1 END)
    FROM Inspecciones insp
    WHERE insp.inspFecha BETWEEN @FechaInicio AND @FechaFin;
END;

GO

DECLARE @CantidadOficinaNoEncontrada INT;
DECLARE @CantidadSinComentarios INT;
DECLARE @FechaInicio DATE = '2023-01-01';
DECLARE @FechaFin DATE = '2024-03-31';

EXEC ObtenerInspeccionesPorRangoFecha @FechaInicio, @FechaFin, @CantidadOficinaNoEncontrada OUTPUT, @CantidadSinComentarios OUTPUT;

PRINT 'Cantidad de inspecciones con resultado ''Oficina no encontrada'': ' + CAST(@CantidadOficinaNoEncontrada AS VARCHAR(10))
PRINT 'Cantidad de inspecciones sin comentarios: ' + CAST(@CantidadSinComentarios AS VARCHAR(10));
