/*

TRIGGERS

*/


--Trigger 1: 
/*Cada vez que se crea un nuevo establecimiento, se debe crear una licencia de aprobaci�n con vencimiento 90 d�as, 
el disparador debe ser escrito teniendo en cuenta la posibilidad de ingresos m�ltiples.*/
GO
CREATE TRIGGER CrearLicenciaNuevoEstablecimiento
ON Establecimientos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NuevoEstablecimientoID INT;
    DECLARE @FechaEmision DATE;
    DECLARE @FechaVencimiento DATE;

    SELECT @NuevoEstablecimientoID = estNumero FROM inserted;

    -- Calcular fecha de emisi�n y vencimiento
    SET @FechaEmision = GETDATE();
    SET @FechaVencimiento = DATEADD(day, 90, @FechaEmision);

    -- Insertar nueva licencia para el establecimiento creado
    INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus)
    VALUES (@NuevoEstablecimientoID, @FechaEmision, @FechaVencimiento, 'APR');
END;
GO

/*PRECARGA DE PRUEBA:

INSERT INTO Establecimientos (estNombre, estDireccion, estTelefono, estLatitud, estLongitud) 
VALUES ('Camino Arabe', 'Punta Carretas, Montevideo', '+233153721', 45.1218, -74.1320);

SELECT lic.licNumero, lic.estNumero, lic.licStatus
FROM Licencias lic
JOIN Establecimientos est ON est.estNumero = lic.estNumero
WHERE est.estNombre = 'Camino Arabe';
*/

--Trigger 2: 
/*No permitir que se ingresen inspecciones de establecimientos cuya licencia est� pr�xima a vencer, 
se entiende por pr�xima a vencer a todas aquellas cuyo vencimiento est� dentro de los siguientes 5 d�as, 
el disparador debe tener en cuenta la posibilidad de registros m�ltiples.*/
CREATE TRIGGER trg_prevenir_inspeccion_licencia_proxima_vencer
ON Inspecciones
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @fechaActual DATE = GETDATE();

    -- Verificar si hay registros en la tabla insertada que tengan una licencia correspondiente que vence dentro de los pr�ximos 5 d�as
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        JOIN Licencias l ON i.estNumero = l.estNumero
        WHERE l.licFchVto BETWEEN @fechaActual AND DATEADD(day, 5, @fechaActual)
    )
    BEGIN
        -- Generar un error para evitar la inserci�n
        RAISERROR ('No se pueden ingresar inspecciones para establecimientos con licencias pr�ximas a vencer en los pr�ximos 5 d�as.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Si no existen tales registros, permitir la inserci�n
    INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
    SELECT inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents
    FROM Inserted;
END;
GO

/*PRECARGA DE PRUEBA:

INSERT INTO Establecimientos (estNombre, estDireccion, estTelefono, estLatitud, estLongitud)
VALUES ('Establecimiento A', 'Direcci�n A', '1234567890', 0.0, 0.0);

INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus)
VALUES ((SELECT est.estNumero FROM Establecimientos est WHERE est.estNombre = 'Establecimiento A'), '2024-01-01', DATEADD(day, 3, GETDATE()), 'APR');

DECLARE @IdEst22 INT;
SELECT @IdEst22 = estNumero
FROM Establecimientos
WHERE estNombre = 'Establecimiento A';

DECLARE @IdTP8 INT;
SELECT @IdTP8 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Incumplimientos de seguridad';

INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2024-06-11 09:00:00', 120), @IdEst22, 'Bajo', 'Pasa', @IdTP8, 'Manipulaci�n dudosa y falta de capacitaci�n.');
*/


