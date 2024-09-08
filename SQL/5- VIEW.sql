/*

Vistas

*/

--Vista: Escribir una vista que muestre todos los datos de las licencias vigentes 
--y los días que faltan para el vencimiento de cada una de ellas.
CREATE VIEW LicenciasVigentesConDiasRestantes AS
SELECT 
    lic.licNumero,
    lic.estNumero,
    est.estNombre AS NombreEstablecimiento,
    lic.licFchEmision,
    lic.licFchVto,
    DATEDIFF(day, GETDATE(), lic.licFchVto) AS DiasRestantes
FROM Licencias lic
JOIN Establecimientos est ON lic.estNumero = est.estNumero
WHERE lic.licStatus = 'APR' AND lic.licFchVto >= GETDATE();


--SELECT * FROM LicenciasVigentesConDiasRestantes;

