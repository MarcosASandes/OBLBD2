/*

3) Consultas.

*/

--Consulta 1: 
/*Mostrar nombre, direcci�n y tel�fono de los establecimientos que tuvieron la inspecci�n fallida m�s reciente.*/
SELECT e.estNombre AS NombreEstablecimiento, 
       e.estDireccion AS DireccionEstablecimiento, 
       e.estTelefono AS TelefonoEstablecimiento
FROM Establecimientos e
JOIN Inspecciones ins ON e.estNumero = ins.estNumero
WHERE ins.inspResultado = 'Falla'
AND ins.inspFecha = (
    SELECT MAX(inspFecha) -- Subconsulta para obtener la inspecci�n m�s reciente.
    FROM Inspecciones
    WHERE inspResultado = 'Falla'
);




--Consulta 2: 
/*Mostrar los 5 tipos de violaciones mas comunes, el informe debe mostrar c�digo y descripci�n de la violaci�n 
y cantidad de inspecciones en el a�o presente.*/
SELECT TOP 5 tv.violCodigo AS CodViolacion, tv.violDescrip AS Descripcion, COUNT(*) AS CantidadDeInspecciones
FROM TipoViolacion tv
JOIN Inspecciones insp ON tv.violCodigo = insp.violCodigo
WHERE YEAR(insp.inspFecha) = YEAR(GETDATE())
GROUP BY tv.violCodigo, tv.violDescrip
ORDER BY COUNT(*) DESC;



--Consulta 3: 
/*Mostrar n�mero y nombre de los establecimientos que cometieron todos los tipos de violaci�n que existen.*/
SELECT e.estNumero AS NumeroEstablecimiento, e.estNombre AS Nombre
FROM Establecimientos e
WHERE NOT EXISTS (
    SELECT tv.violCodigo
    FROM TipoViolacion tv
    WHERE NOT EXISTS (
        SELECT 1
        FROM Inspecciones insp
        WHERE insp.estNumero = e.estNumero
        AND insp.violCodigo = tv.violCodigo
    )
);



--Consulta 4: 
/*Mostrar el porcentaje de inspecciones reprobadas por cada establecimiento, 
incluir dentro de la reprobaci�n las categor�as 'Falla', 'Pasa con condiciones'.*/
SELECT e.estNumero AS NumeroEstablecimiento, e.estNombre AS Nombre,
       (COUNT(CASE WHEN insp.inspResultado IN ('Falla', 'Pasa con condiciones') THEN 1 END) * 100 / COUNT(*)) AS PorcentajeReprobado
FROM Establecimientos e
JOIN Inspecciones insp ON e.estNumero = insp.estNumero
GROUP BY e.estNumero, e.estNombre;



--Consulta 5: 
/*Mostrar el ranking de inspecciones de establecimientos, dicho ranking debe mostrar n�mero y nombre del establecimiento, 
total de inspecciones, total de inspecciones aprobadas ('Pasa'), porcentaje de dichas inspecciones aprobadas, 
total de inspecciones reprobadas ('Falla', 'Pasa con condiciones') y porcentaje de dichas inspecciones reprobadas, 
solo tener en cuenta establecimientos cuyo status de licencia es APR.*/
SELECT e.estNumero AS NumeroEstablecimiento, e.estNombre AS Nombre,
       COUNT(insp.inspID) AS TotalInspecciones,
       SUM(CASE WHEN insp.inspResultado = 'Pasa' THEN 1 ELSE 0 END) AS TotalAprobadas,
       CAST(SUM(CASE WHEN insp.inspResultado = 'Pasa' THEN 1 ELSE 0 END) * 100.0 / COUNT(insp.inspID) AS DECIMAL(5,2)) AS PorcentajeAprobadas,
       SUM(CASE WHEN insp.inspResultado IN ('Falla', 'Pasa con condiciones') THEN 1 ELSE 0 END) AS TotalReprobadas,
       CAST(SUM(CASE WHEN insp.inspResultado IN ('Falla', 'Pasa con condiciones') THEN 1 ELSE 0 END) * 100.0 / COUNT(insp.inspID) AS DECIMAL(5,2)) AS PorcentajeReprobadas
FROM Establecimientos e
JOIN Inspecciones insp ON e.estNumero = insp.estNumero
JOIN Licencias lic ON e.estNumero = lic.estNumero
WHERE lic.licStatus = 'APR'
GROUP BY e.estNumero, e.estNombre
ORDER BY TotalInspecciones DESC;



--Consulta 6: Actual.
/*Mostrar la diferencia de d�as en que cada establecimiento renov� su licencia.*/
SELECT est.estNumero, est.estNombre, DATEDIFF(day, lic.licFchEmision, lic.licFchVto) AS DiferenciaDias
FROM Establecimientos est
INNER JOIN Licencias lic ON est.estNumero = lic.estNumero








