/*

1) Creación de los índices necesarios.

*/


--LICENCIAS
CREATE INDEX idx_NumEstablecimiento ON Licencias (estNumero)

--INSPECCIONES
CREATE INDEX idx_NumEstablecimiento ON Inspecciones (estNumero)
CREATE INDEX idx_CodViolacion ON Inspecciones (violCodigo)


/*
2) Precarga definitiva de datos de prueba.

OBL BD2 - Marcos Sandes.
*/

/*
		I) Establecimientos:
			Cantidad: 20.
*/

--ESTABLECIMIENTOS.
INSERT INTO Establecimientos (estNombre, estDireccion, estTelefono, estLatitud, estLongitud) 
VALUES ('La Cocina de María', 'Palmares, Canelones', '+123456789', 40.7128, -74.0060),
       ('Bella Napoli', 'Avenida 18, Montevideo', '+987654321', 34.0522, -118.2437),
       ('El Rincón del Café', 'Miranda, Montevideo', '+543210987', 51.5074, -0.1278),
       ('La Baguette', 'General Flores, Montevideo', '+112233445', 48.8566, 2.3522),
       ('Big Burger', 'Medanos, Canelones', '+667788999', 19.4326, -99.1332),
       ('El Sabor de México', 'Solymar, Canelones', '+111222333', 37.7749, -122.4194),
       ('Parrilla Don Juan', 'Parque del plata, Canelones', '+444555666', -33.8688, 151.2093),
       ('La Esquina del Sabor', 'Jacinto Vera, Montevideo', '+123123123', 35.6895, 139.6917),
       ('La Rústica', 'Pocitos, Montevideo', '+789789789', -22.9068, -43.1729),
       ('Sabor Oriental', 'Punta Carretas, Montevideo', '+333444555', -34.6037, -58.3816),
       ('Aroma de Café', 'Ciudad Vieja, Montevideo', '+555444333', 51.5074, -0.1278),
       ('Dulce Tentación', 'Soriano, Montevideo', '+321654987', 37.7749, -122.4194),
       ('Burguer Master', 'Calle Artigas, Salto', '+999888777', 35.6895, 139.6917),
       ('La Trattoria', 'Sarandi, Maldonado', '+777666555', -22.9068, -43.1729),
       ('Parrillada La Argentina', 'Gorlero, Maldonado', '+222333444', -34.6037, -58.3816),
       ('El Cafecito', 'Bulevar España, Montevideo', '+111222333', 40.7128, -74.0060),
       ('Pizza Express', 'Calle Estuani, Montevideo', '+888777666', 34.0522, -118.2437),
       ('El Rincón de las Carnes', 'Tres Cruces, Montevideo', '+666555444', 51.5074, -0.1278),
       ('Pan y Más', 'Unión, Montevideo', '+777888999', 48.8566, 2.3522),
       ('Burgerland', 'Flor de Maroñas, Montevideo', '+333222111', 19.4326, -99.1332);




/*
		II) TipoViolacion:
			Cantidad: 11.
*/

--TIPOVIOLACION
INSERT INTO TipoViolacion (violDescrip) 
VALUES ('Mal manejo de alimentos'),
       ('Falta de higiene'),
       ('Almacenamiento incorrecto'),
       ('Ingredientes vencidos'),
       ('Contaminación cruzada'),
       ('Falta de control temperatura'),
       ('Malas prácticas de limpieza'),
       ('Incumplimientos de seguridad'),
       ('Manipulación inadecuada'),
       ('Falta de capacitación'),
	   ('Oficina no encontrada');




/*
		III) Inspecciones y Licencias:
			 Cantidad inspecciones: 159.
			 Cantidad licencias: 159.
			 Información adicional: Si una inspección tiene status "Pasa", la licencia durará 3 meses.
									Si una inspección tiene status "Pasa con condiciones", la licencia durará 2 meses.
									Si una inspección tiene status "Falla", se deberá repetir la inspección dentro de 1 mes.
*/

/*

IMPORTANTE:
Al tener claves primarias autoincrementales tanto Establecimiento, como TipoViolacion, para inspecciones y licencias no puedo hardcodear los valores de IDs
en las columnas que los requieren, puesto que, al menos en los testeos hechos, siempre el IDENTITY de las claves genera algún conflicto. Por ello decidí solucionarlo
creando una variable para cada establecimiento y cada tipoviolacion con los cuales se podrán hacer las inserciones previstas de Licencias e Inspecciones.
*/

--24
DECLARE @IdTP1 INT;
SELECT @IdTP1 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Mal manejo de alimentos';

--25
DECLARE @IdTP2 INT;
SELECT @IdTP2 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Falta de higiene';

--26
DECLARE @IdTP3 INT;
SELECT @IdTP3 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Almacenamiento incorrecto';

--27
DECLARE @IdTP4 INT;
SELECT @IdTP4 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Ingredientes vencidos';

--28
DECLARE @IdTP5 INT;
SELECT @IdTP5 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Contaminación cruzada';

--29
DECLARE @IdTP6 INT;
SELECT @IdTP6 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Falta de control temperatura';

--30
DECLARE @IdTP7 INT;
SELECT @IdTP7 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Malas prácticas de limpieza';

--31
DECLARE @IdTP8 INT;
SELECT @IdTP8 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Incumplimientos de seguridad';

--32
DECLARE @IdTP9 INT;
SELECT @IdTP9 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Manipulación inadecuada';

--33
DECLARE @IdTP10 INT;
SELECT @IdTP10 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Falta de capacitación';

--34
DECLARE @IdTP11 INT;
SELECT @IdTP11 = violCodigo
FROM TipoViolacion
WHERE violDescrip = 'Oficina no encontrada';



--|||||||||||||||||||||||||||||
DECLARE @IdEst1 INT;
SELECT @IdEst1 = estNumero
FROM Establecimientos
WHERE estNombre = 'La Cocina de María';

INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-15 09:00:00', 120), @IdEst1, 'Alto', 'Oficina no encontrada', @IdTP11, 'Oficina no encontrada.'),
       (CONVERT(datetime, '2023-02-01 09:00:00', 120), @IdEst1, 'Medio', 'Pasa con condiciones', @IdTP5, 'Contaminación cruzada'),
       (CONVERT(datetime, '2023-04-05 09:00:00', 120), @IdEst1, 'Bajo', 'Pasa', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst1, 'Alto', 'Falla', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-08-01 09:00:00', 120), @IdEst1, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-11-05 09:00:00', 120), @IdEst1, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-02-05 09:00:00', 120), @IdEst1, 'Medio', 'Pasa con condiciones', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst1, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst2 INT;
SELECT @IdEst2 = estNumero
FROM Establecimientos
WHERE estNombre = 'Bella Napoli';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-15 09:00:00', 120), @IdEst2, 'Alto', 'Falla', @IdTP1, 'Mal manejo de alimentos'),
       (CONVERT(datetime, '2023-02-01 09:00:00', 120), @IdEst2, 'Medio', 'Falla', @IdTP2, 'Falta de higiene.'),
       (CONVERT(datetime, '2023-03-02 09:00:00', 120), @IdEst2, 'Alto', 'Oficina no encontrada', @IdTP11, 'Oficina no encontrada.'),
       (CONVERT(datetime, '2023-04-01 09:00:00', 120), @IdEst2, 'Alto', 'Falla', @IdTP4, 'Ingredientes vencidos.'),
       (CONVERT(datetime, '2023-05-01 09:00:00', 120), @IdEst2, 'Medio', 'Falla', @IdTP5, 'Contaminación cruzada.'),
       (CONVERT(datetime, '2023-06-05 09:00:00', 120), @IdEst2, 'Alto', 'Falla', @IdTP6, 'Falta de control temperatura.'),
       (CONVERT(datetime, '2023-07-06 09:00:00', 120), @IdEst2, 'Alto', 'Falla', @IdTP7, 'Malas prácticas de limpieza.'),
       (CONVERT(datetime, '2023-08-12 09:00:00', 120), @IdEst2, 'Medio', 'Falla', @IdTP8, 'Incumplimiento de seguridad.'),
       (CONVERT(datetime, '2023-09-02 09:00:00', 120), @IdEst2, 'Medio', 'Falla', @IdTP9, 'Manipulación inadecuada.'),
       (CONVERT(datetime, '2023-10-03 09:00:00', 120), @IdEst2, 'Alto', 'Falla', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-11-07 09:00:00', 120), @IdEst2, 'Medio', 'Pasa con condiciones', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-01-02 09:00:00', 120), @IdEst2, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst2, 'Bajo', 'Pasa', @IdTP4, 'Ingredientes vencidos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst3 INT;
SELECT @IdEst3 = estNumero
FROM Establecimientos
WHERE estNombre = 'El Rincón del Café';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-05-18 09:00:00', 120), @IdEst3, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina'),
       (CONVERT(datetime, '2023-08-04 09:00:00', 120), @IdEst3, 'Bajo', 'Pasa con condiciones', @IdTP5, 'Contaminación cruzada'),
       (CONVERT(datetime, '2023-11-05 09:00:00', 120), @IdEst3, 'Medio', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-02-02 09:00:00', 120), @IdEst3, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-05-02 09:00:00', 120), @IdEst3, 'Bajo', 'Falla', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-06-02 09:00:00', 120), @IdEst3, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst4 INT;
SELECT @IdEst4 = estNumero
FROM Establecimientos
WHERE estNombre = 'La Baguette';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-02-24 09:00:00', 120), @IdEst4, 'Medio', 'Pasa con condiciones', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-04-08 09:00:00', 120), @IdEst4, 'Medio', 'Pasa con condiciones', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-06-02 09:00:00', 120), @IdEst4, 'Alto', 'Falla', @IdTP4, 'Ingredientes vencidos.'),
       (CONVERT(datetime, '2023-07-01 09:00:00', 120), @IdEst4, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2023-10-11 09:00:00', 120), @IdEst4, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-12-06 09:00:00', 120), @IdEst4, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-03-05 09:00:00', 120), @IdEst4, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-06-05 09:00:00', 120), @IdEst4, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst5 INT;
SELECT @IdEst5 = estNumero
FROM Establecimientos
WHERE estNombre = 'Big Burger';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-01 09:00:00', 120), @IdEst5, 'Bajo', 'Pasa', @IdTP8, 'Incumplimiento de seguridad.'),
       (CONVERT(datetime, '2023-04-02 09:00:00', 120), @IdEst5, 'Alto', 'Falla', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-05-03 09:00:00', 120), @IdEst5, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2023-08-02 09:00:00', 120), @IdEst5, 'Medio', 'Falla', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-09-02 09:00:00', 120), @IdEst5, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-12-04 09:00:00', 120), @IdEst5, 'Alto', 'Falla', @IdTP2, 'Falta de higiene.'),
       (CONVERT(datetime, '2024-01-05 09:00:00', 120), @IdEst5, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-04-05 09:00:00', 120), @IdEst5, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst6 INT;
SELECT @IdEst6 = estNumero
FROM Establecimientos
WHERE estNombre = 'El Sabor de México';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-02-16 09:00:00', 120), @IdEst6, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-04-22 09:00:00', 120), @IdEst6, 'Bajo', 'Pasa', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-07-05 09:00:00', 120), @IdEst6, 'Alto', 'Falla', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-08-02 09:00:00', 120), @IdEst6, 'Bajo', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-10-03 09:00:00', 120), @IdEst6, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina.'),
       (CONVERT(datetime, '2024-01-05 09:00:00', 120), @IdEst6, 'Alto', 'Falla', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-02-05 09:00:00', 120), @IdEst6, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-05-05 09:00:00', 120), @IdEst6, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst7 INT;
SELECT @IdEst7 = estNumero
FROM Establecimientos
WHERE estNombre = 'Parrilla Don Juan';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2022-12-15 09:00:00', 120), @IdEst7, 'Bajo', 'Pasa', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-03-01 09:00:00', 120), @IdEst7, 'Alto', 'Falla', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2023-04-05 09:00:00', 120), @IdEst7, 'Bajo', 'Pasa con condiciones', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-06-03 09:00:00', 120), @IdEst7, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-09-01 09:00:00', 120), @IdEst7, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina.'),
       (CONVERT(datetime, '2023-12-05 09:00:00', 120), @IdEst7, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-03-06 09:00:00', 120), @IdEst7, 'Alto', 'Falla', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst7, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst8 INT;
SELECT @IdEst8 = estNumero
FROM Establecimientos
WHERE estNombre = 'La Esquina del Sabor';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-14 09:00:00', 120), @IdEst8, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina'),
       (CONVERT(datetime, '2023-04-18 09:00:00', 120), @IdEst8, 'Medio', 'Pasa con condiciones', @IdTP6, 'Falta de control temperatura.'),
       (CONVERT(datetime, '2023-06-05 09:00:00', 120), @IdEst8, 'Alto', 'Falla', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst8, 'Bajo', 'Pasa', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-10-03 09:00:00', 120), @IdEst8, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-01-05 09:00:00', 120), @IdEst8, 'Alto', 'Falla', @IdTP2, 'Falta de higiene en la cocina.'),
       (CONVERT(datetime, '2024-02-08 09:00:00', 120), @IdEst8, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-05-08 09:00:00', 120), @IdEst8, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst9 INT;
SELECT @IdEst9 = estNumero
FROM Establecimientos
WHERE estNombre = 'La Rústica';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-01 09:00:00', 120), @IdEst9, 'Medio', 'Pasa con condiciones', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-03-02 09:00:00', 120), @IdEst9, 'Alto', 'Falla', @IdTP5, 'Contaminación cruzada'),
       (CONVERT(datetime, '2023-04-03 09:00:00', 120), @IdEst9, 'Bajo', 'Pasa', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst9, 'Alto', 'Falla', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-08-06 09:00:00', 120), @IdEst9, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-10-02 09:00:00', 120), @IdEst9, 'Alto', 'Falla', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2023-11-02 09:00:00', 120), @IdEst9, 'Alto', 'Falla', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-12-01 09:00:00', 120), @IdEst9, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2024-03-02 09:00:00', 120), @IdEst9, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2024-06-02 09:00:00', 120), @IdEst9, 'Alto', 'Falla', @IdTP9, 'Dudosa manipulación.');




--|||||||||||||||||||||||||||||
DECLARE @IdEst10 INT;
SELECT @IdEst10 = estNumero
FROM Establecimientos
WHERE estNombre = 'Sabor Oriental';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-05-12 09:00:00', 120), @IdEst10, 'Medio', 'Pasa con condiciones', @IdTP4, 'Ingredientes vencidos.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst10, 'Alto', 'Falla', @IdTP3, 'Almacenamiento incorrecto.'),
       (CONVERT(datetime, '2023-08-03 09:00:00', 120), @IdEst10, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento incorrecto.'),
       (CONVERT(datetime, '2023-11-07 09:00:00', 120), @IdEst10, 'Bajo', 'Pasa con condiciones', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2024-01-04 09:00:00', 120), @IdEst10, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-04-04 09:00:00', 120), @IdEst10, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst11 INT;
SELECT @IdEst11 = estNumero
FROM Establecimientos
WHERE estNombre = 'Aroma de Café';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-15 09:00:00', 120), @IdEst11, 'Alto', 'Falla', @IdTP2, 'Falta de higiene.'),
       (CONVERT(datetime, '2023-02-01 09:00:00', 120), @IdEst11, 'Medio', 'Falla', @IdTP1, 'Mal manejo de alimentos'),
       (CONVERT(datetime, '2023-03-02 09:00:00', 120), @IdEst11, 'Alto', 'Oficina no encontrada', @IdTP11, 'Oficina no encontrada.'),
       (CONVERT(datetime, '2023-04-01 09:00:00', 120), @IdEst11, 'Alto', 'Falla', @IdTP3, 'Almacenamiento incorrecto.'),
       (CONVERT(datetime, '2023-05-01 09:00:00', 120), @IdEst11, 'Medio', 'Falla', @IdTP5, 'Contaminación cruzada.'),
       (CONVERT(datetime, '2023-06-05 09:00:00', 120), @IdEst11, 'Alto', 'Falla', @IdTP6, 'Falta de control temperatura.'),
       (CONVERT(datetime, '2023-07-06 09:00:00', 120), @IdEst11, 'Alto', 'Falla', @IdTP7, 'Malas prácticas de limpieza.'),
       (CONVERT(datetime, '2023-08-12 09:00:00', 120), @IdEst11, 'Medio', 'Falla', @IdTP8, 'Incumplimiento de seguridad.'),
       (CONVERT(datetime, '2023-09-02 09:00:00', 120), @IdEst11, 'Medio', 'Falla', @IdTP9, 'Manipulación inadecuada.'),
       (CONVERT(datetime, '2023-10-03 09:00:00', 120), @IdEst11, 'Alto', 'Falla', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-11-07 09:00:00', 120), @IdEst11, 'Medio', 'Pasa con condiciones', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-01-02 09:00:00', 120), @IdEst11, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst11, 'Bajo', 'Pasa', @IdTP4, 'Ingredientes vencidos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst12 INT;
SELECT @IdEst12 = estNumero
FROM Establecimientos
WHERE estNombre = 'Dulce Tentación';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2022-12-15 09:00:00', 120), @IdEst12, 'Bajo', 'Pasa', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-03-01 09:00:00', 120), @IdEst12, 'Alto', 'Falla', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2023-04-05 09:00:00', 120), @IdEst12, 'Bajo', 'Pasa con condiciones', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-06-03 09:00:00', 120), @IdEst12, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-09-01 09:00:00', 120), @IdEst12, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina.'),
       (CONVERT(datetime, '2023-12-05 09:00:00', 120), @IdEst12, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-03-06 09:00:00', 120), @IdEst12, 'Alto', 'Falla', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst12, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst13 INT;
SELECT @IdEst13 = estNumero
FROM Establecimientos
WHERE estNombre = 'Burguer Master';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-02-24 09:00:00', 120), @IdEst13, 'Medio', 'Pasa con condiciones', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-04-08 09:00:00', 120), @IdEst13, 'Medio', 'Pasa con condiciones', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-06-02 09:00:00', 120), @IdEst13, 'Alto', 'Falla', @IdTP4, 'Ingredientes vencidos.'),
       (CONVERT(datetime, '2023-07-01 09:00:00', 120), @IdEst13, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2023-10-11 09:00:00', 120), @IdEst13, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-12-06 09:00:00', 120), @IdEst13, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-03-05 09:00:00', 120), @IdEst13, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-06-05 09:00:00', 120), @IdEst13, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');

	   

--|||||||||||||||||||||||||||||
DECLARE @IdEst14 INT;
SELECT @IdEst14 = estNumero
FROM Establecimientos
WHERE estNombre = 'La Trattoria';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-16 09:00:00', 120), @IdEst14, 'Alto', 'Falla', @IdTP1, 'Mal manejo de alimentos.'),
       (CONVERT(datetime, '2023-02-03 09:00:00', 120), @IdEst14, 'Medio', 'Falla', @IdTP1, 'Mal manejo de alimentos.'),
       (CONVERT(datetime, '2023-03-02 09:00:00', 120), @IdEst14, 'Alto', 'Falla', @IdTP4, 'Ingredientes vencidos.'),
       (CONVERT(datetime, '2023-04-01 09:00:00', 120), @IdEst14, 'Alto', 'Falla', @IdTP3, 'Almacenamiento incorrecto.'),
       (CONVERT(datetime, '2023-05-01 09:00:00', 120), @IdEst14, 'Medio', 'Falla', @IdTP5, 'Contaminación cruzada.'),
       (CONVERT(datetime, '2023-06-06 09:00:00', 120), @IdEst14, 'Alto', 'Falla', @IdTP6, 'Falta de control temperatura.'),
       (CONVERT(datetime, '2023-07-06 09:00:00', 120), @IdEst14, 'Alto', 'Falla', @IdTP7, 'Malas prácticas de limpieza.'),
       (CONVERT(datetime, '2023-08-12 09:00:00', 120), @IdEst14, 'Medio', 'Falla', @IdTP8, 'Incumplimiento de seguridad.'),
       (CONVERT(datetime, '2023-09-02 09:00:00', 120), @IdEst14, 'Medio', 'Falla', @IdTP9, 'Manipulación inadecuada.'),
       (CONVERT(datetime, '2023-10-03 09:00:00', 120), @IdEst14, 'Alto', 'Falla', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-11-07 09:00:00', 120), @IdEst14, 'Medio', 'Pasa con condiciones', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-01-02 09:00:00', 120), @IdEst14, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-04-04 09:00:00', 120), @IdEst14, 'Bajo', 'Pasa', @IdTP4, 'Ingredientes vencidos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst15 INT;
SELECT @IdEst15 = estNumero
FROM Establecimientos
WHERE estNombre = 'Parrillada La Argentina';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-01 09:00:00', 120), @IdEst15, 'Medio', 'Pasa con condiciones', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-03-02 09:00:00', 120), @IdEst15, 'Alto', 'Falla', @IdTP5, 'Contaminación cruzada'),
       (CONVERT(datetime, '2023-04-03 09:00:00', 120), @IdEst15, 'Bajo', 'Pasa', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst15, 'Alto', 'Falla', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-08-06 09:00:00', 120), @IdEst15, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-10-02 09:00:00', 120), @IdEst15, 'Alto', 'Falla', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2023-11-02 09:00:00', 120), @IdEst15, 'Alto', 'Falla', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-12-01 09:00:00', 120), @IdEst15, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2024-03-02 09:00:00', 120), @IdEst15, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst16 INT;
SELECT @IdEst16 = estNumero
FROM Establecimientos
WHERE estNombre = 'El Cafecito';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-05-19 09:00:00', 120), @IdEst16, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina'),
       (CONVERT(datetime, '2023-08-06 09:00:00', 120), @IdEst16, 'Bajo', 'Pasa con condiciones', @IdTP5, 'Contaminación cruzada'),
       (CONVERT(datetime, '2023-11-07 09:00:00', 120), @IdEst16, 'Medio', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-02-03 09:00:00', 120), @IdEst16, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.'),
       (CONVERT(datetime, '2024-05-03 09:00:00', 120), @IdEst16, 'Bajo', 'Pasa', @IdTP3, 'Almacenamiento inadecuado.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst17 INT;
SELECT @IdEst17 = estNumero
FROM Establecimientos
WHERE estNombre = 'Pizza Express';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-02-16 09:00:00', 120), @IdEst17, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-04-22 09:00:00', 120), @IdEst17, 'Bajo', 'Pasa', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-07-05 09:00:00', 120), @IdEst17, 'Alto', 'Falla', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-08-02 09:00:00', 120), @IdEst17, 'Bajo', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-10-03 09:00:00', 120), @IdEst17, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina.'),
       (CONVERT(datetime, '2024-01-05 09:00:00', 120), @IdEst17, 'Alto', 'Falla', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-02-05 09:00:00', 120), @IdEst17, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst18 INT;
SELECT @IdEst18 = estNumero
FROM Establecimientos
WHERE estNombre = 'El Rincón de las Carnes';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2022-12-14 09:00:00', 120), @IdEst18, 'Bajo', 'Pasa', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-03-02 09:00:00', 120), @IdEst18, 'Alto', 'Falla', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2023-04-08 09:00:00', 120), @IdEst18, 'Bajo', 'Pasa con condiciones', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-06-04 09:00:00', 120), @IdEst18, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-09-02 09:00:00', 120), @IdEst18, 'Bajo', 'Pasa', @IdTP2, 'Falta de higiene en la cocina.'),
       (CONVERT(datetime, '2023-12-07 09:00:00', 120), @IdEst18, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-03-06 09:00:00', 120), @IdEst18, 'Alto', 'Falla', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst18, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst19 INT;
SELECT @IdEst19 = estNumero
FROM Establecimientos
WHERE estNombre = 'Pan y Más';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-01-15 09:00:00', 120), @IdEst19, 'Alto', 'Falla', @IdTP2, 'Falta de higiene en la cocina'),
       (CONVERT(datetime, '2023-02-01 09:00:00', 120), @IdEst19, 'Medio', 'Pasa con condiciones', @IdTP5, 'Contaminación cruzada'),
       (CONVERT(datetime, '2023-04-05 09:00:00', 120), @IdEst19, 'Bajo', 'Pasa', @IdTP9, 'Manipulación dudosa.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst19, 'Alto', 'Falla', @IdTP10, 'Manipulación dudosa y falta de capacitación.'),
       (CONVERT(datetime, '2023-08-01 09:00:00', 120), @IdEst19, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-11-05 09:00:00', 120), @IdEst19, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-02-05 09:00:00', 120), @IdEst19, 'Medio', 'Pasa con condiciones', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-04-02 09:00:00', 120), @IdEst19, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.');



--|||||||||||||||||||||||||||||
DECLARE @IdEst20 INT;
SELECT @IdEst20 = estNumero
FROM Establecimientos
WHERE estNombre = 'Burgerland';


INSERT INTO Inspecciones (inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES (CONVERT(datetime, '2023-02-22 09:00:00', 120), @IdEst20, 'Medio', 'Pasa con condiciones', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-04-09 09:00:00', 120), @IdEst20, 'Medio', 'Pasa con condiciones', @IdTP10, 'Falta de capacitación.'),
       (CONVERT(datetime, '2023-06-03 09:00:00', 120), @IdEst20, 'Alto', 'Falla', @IdTP4, 'Ingredientes vencidos.'),
       (CONVERT(datetime, '2023-07-02 09:00:00', 120), @IdEst20, 'Bajo', 'Pasa', @IdTP9, 'Dudosa manipulación.'),
       (CONVERT(datetime, '2023-10-12 09:00:00', 120), @IdEst20, 'Medio', 'Pasa con condiciones', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2023-12-07 09:00:00', 120), @IdEst20, 'Bajo', 'Pasa', @IdTP1, 'Manejo inadecuado de alimentos.'),
       (CONVERT(datetime, '2024-03-05 09:00:00', 120), @IdEst20, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.'),
       (CONVERT(datetime, '2024-06-05 09:00:00', 120), @IdEst20, 'Bajo', 'Pasa', @IdTP4, 'Alimentos dudosos.');


--////////////////////////////////////////////////////////////////////////////////


--Licencias para EST 1:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst1, '2023-01-15', '2023-02-01', 'REV'),
	   (@IdEst1, '2023-02-01', '2023-04-01', 'APR'),
	   (@IdEst1, '2023-04-05', '2023-07-01', 'APR'),
	   (@IdEst1, '2023-07-02', '2023-08-01', 'REV'),
	   (@IdEst1, '2023-08-01', '2023-11-01', 'APR'),
	   (@IdEst1, '2023-11-05', '2024-02-01', 'APR'),
	   (@IdEst1, '2024-02-05', '2024-04-01', 'APR'),
	   (@IdEst1, '2024-04-02', '2024-07-01', 'APR');


--Licencias para EST 2:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst2, '2023-01-15', '2023-02-01', 'REV'),
	   (@IdEst2, '2023-02-01', '2023-03-01', 'REV'),
	   (@IdEst2, '2023-03-02', '2023-04-01', 'REV'),
	   (@IdEst2, '2023-04-01', '2023-05-01', 'REV'),
	   (@IdEst2, '2023-05-01', '2023-06-01', 'REV'),
	   (@IdEst2, '2023-06-05', '2023-07-01', 'REV'),
	   (@IdEst2, '2023-07-06', '2024-08-01', 'REV'),
	   (@IdEst2, '2023-08-12', '2024-09-01', 'REV'),
	   (@IdEst2, '2023-09-02', '2023-10-01', 'REV'),
	   (@IdEst2, '2023-10-03', '2023-11-01', 'REV'),
	   (@IdEst2, '2023-11-07', '2024-01-01', 'APR'),
	   (@IdEst2, '2024-01-02', '2024-04-01', 'APR'),
	   (@IdEst2, '2024-04-02', '2024-07-01', 'APR');

	   
--Licencias para EST 3:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst3, '2023-05-18', '2023-08-01', 'APR'),
	   (@IdEst3, '2023-08-04', '2023-11-01', 'APR'),
	   (@IdEst3, '2023-11-05', '2024-02-01', 'APR'),
	   (@IdEst3, '2024-02-02', '2024-05-01', 'APR'),
	   (@IdEst3, '2024-05-02', '2024-06-01', 'REV'),
	   (@IdEst3, '2024-06-02', '2024-09-01', 'APR');


--Licencias para EST 4:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst4, '2023-02-24', '2023-04-01', 'APR'),
	   (@IdEst4, '2023-04-08', '2023-06-01', 'APR'),
	   (@IdEst4, '2023-06-02', '2023-07-01', 'REV'),
	   (@IdEst4, '2023-07-01', '2023-10-01', 'APR'),
	   (@IdEst4, '2023-10-11', '2023-12-01', 'APR'),
	   (@IdEst4, '2023-12-06', '2024-03-01', 'APR'),
	   (@IdEst4, '2024-03-05', '2024-06-01', 'APR'),
	   (@IdEst4, '2024-06-05', '2024-09-01', 'APR');


--Licencias para EST 5:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst5, '2023-01-01', '2023-04-01', 'APR'),
	   (@IdEst5, '2023-04-02', '2023-05-01', 'REV'),
	   (@IdEst5, '2023-05-03', '2023-08-01', 'APR'),
	   (@IdEst5, '2023-08-02', '2023-09-01', 'REV'),
	   (@IdEst5, '2023-09-02', '2023-12-01', 'APR'),
	   (@IdEst5, '2023-12-04', '2024-01-01', 'REV'),
	   (@IdEst5, '2024-01-05', '2024-04-01', 'APR'),
	   (@IdEst5, '2024-04-05', '2024-07-01', 'APR');


--Licencias para EST 6:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst6, '2023-02-16', '2023-04-01', 'APR'),
	   (@IdEst6, '2023-04-22', '2023-07-01', 'APR'),
	   (@IdEst6, '2023-07-05', '2023-08-01', 'REV'),
	   (@IdEst6, '2023-08-02', '2023-10-01', 'APR'),
	   (@IdEst6, '2023-10-03', '2024-01-01', 'APR'),
	   (@IdEst6, '2024-01-05', '2024-02-01', 'REV'),
	   (@IdEst6, '2024-02-05', '2024-05-01', 'APR'),
	   (@IdEst6, '2024-05-05', '2024-08-01', 'APR');


--Licencias para EST 7:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst7, '2022-12-15', '2023-03-01', 'APR'),
	   (@IdEst7, '2023-03-01', '2023-04-01', 'REV'),
	   (@IdEst7, '2023-04-05', '2023-06-01', 'APR'),
	   (@IdEst7, '2023-06-03', '2023-09-01', 'APR'),
	   (@IdEst7, '2023-09-01', '2023-12-01', 'APR'),
	   (@IdEst7, '2023-12-05', '2024-03-01', 'APR'),
	   (@IdEst7, '2024-03-06', '2024-04-01', 'REV'),
	   (@IdEst7, '2024-04-02', '2024-07-01', 'APR');


--Licencias para EST 8:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst8, '2023-01-14', '2023-04-01', 'APR'),
	   (@IdEst8, '2023-04-18', '2023-06-01', 'APR'),
	   (@IdEst8, '2023-06-05', '2023-07-01', 'REV'),
	   (@IdEst8, '2023-07-02', '2023-10-01', 'APR'),
	   (@IdEst8, '2023-10-03', '2024-01-01', 'APR'),
	   (@IdEst8, '2024-01-05', '2024-02-01', 'REV'),
	   (@IdEst8, '2024-02-08', '2024-05-01', 'APR'),
	   (@IdEst8, '2024-05-08', '2024-08-01', 'APR');


--Licencias para EST 9:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst9, '2023-01-01', '2023-03-01', 'APR'),
	   (@IdEst9, '2023-03-02', '2023-04-01', 'REV'),
	   (@IdEst9, '2023-04-03', '2023-07-01', 'APR'),
	   (@IdEst9, '2023-07-02', '2023-08-01', 'REV'),
	   (@IdEst9, '2023-08-06', '2023-10-01', 'APR'),
	   (@IdEst9, '2023-10-02', '2023-11-01', 'REV'),
	   (@IdEst9, '2023-11-02', '2023-12-01', 'REV'),
	   (@IdEst9, '2023-12-01', '2024-03-01', 'APR'),
	   (@IdEst9, '2024-03-02', '2024-06-01', 'APR'),
	   (@IdEst9, '2024-06-02', '2024-07-01', 'REV');


--Licencias para EST 10:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst10, '2023-05-12', '2023-07-01', 'APR'),
	   (@IdEst10, '2023-07-02', '2023-08-01', 'REV'),
	   (@IdEst10, '2023-08-03', '2023-11-01', 'APR'),
	   (@IdEst10, '2023-11-07', '2024-01-01', 'APR'),
	   (@IdEst10, '2024-01-04', '2024-04-01', 'APR'),
	   (@IdEst10, '2024-04-04', '2024-07-01', 'APR');


--Licencias para EST 11:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst11, '2023-01-15', '2023-02-01', 'REV'),
	   (@IdEst11, '2023-02-01', '2023-03-01', 'REV'),
	   (@IdEst11, '2023-03-02', '2023-04-01', 'REV'),
	   (@IdEst11, '2023-04-01', '2023-05-01', 'REV'),
	   (@IdEst11, '2023-05-01', '2023-06-01', 'REV'),
	   (@IdEst11, '2023-06-05', '2023-07-01', 'REV'),
	   (@IdEst11, '2023-07-06', '2024-08-01', 'REV'),
	   (@IdEst11, '2023-08-12', '2024-09-01', 'REV'),
	   (@IdEst11, '2023-09-02', '2023-10-01', 'REV'),
	   (@IdEst11, '2023-10-03', '2023-11-01', 'REV'),
	   (@IdEst11, '2023-11-07', '2024-01-01', 'APR'),
	   (@IdEst11, '2024-01-02', '2024-04-01', 'APR'),
	   (@IdEst11, '2024-04-02', '2024-07-01', 'APR');


--Licencias para EST 12:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst12, '2022-12-15', '2023-03-01', 'APR'),
	   (@IdEst12, '2023-03-01', '2023-04-01', 'REV'),
	   (@IdEst12, '2023-04-05', '2023-06-01', 'APR'),
	   (@IdEst12, '2023-06-03', '2023-09-01', 'APR'),
	   (@IdEst12, '2023-09-01', '2023-12-01', 'APR'),
	   (@IdEst12, '2023-12-05', '2024-03-01', 'APR'),
	   (@IdEst12, '2024-03-06', '2024-04-01', 'REV'),
	   (@IdEst12, '2024-04-02', '2024-07-01', 'APR');


--Licencias para EST 13:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst13, '2023-02-24', '2023-04-01', 'APR'),
	   (@IdEst13, '2023-04-08', '2023-06-01', 'APR'),
	   (@IdEst13, '2023-06-02', '2023-07-01', 'REV'),
	   (@IdEst13, '2023-07-01', '2023-10-01', 'APR'),
	   (@IdEst13, '2023-10-11', '2023-12-01', 'APR'),
	   (@IdEst13, '2023-12-06', '2024-03-01', 'APR'),
	   (@IdEst13, '2024-03-05', '2024-06-01', 'APR'),
	   (@IdEst13, '2024-06-05', '2024-09-01', 'APR');


--Licencias para EST 14:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst14, '2023-01-16', '2023-02-01', 'REV'),
	   (@IdEst14, '2023-02-03', '2023-03-01', 'REV'),
	   (@IdEst14, '2023-03-02', '2023-04-01', 'REV'),
	   (@IdEst14, '2023-04-01', '2023-05-01', 'REV'),
	   (@IdEst14, '2023-05-01', '2023-06-01', 'REV'),
	   (@IdEst14, '2023-06-06', '2023-07-01', 'REV'),
	   (@IdEst14, '2023-07-06', '2024-08-01', 'REV'),
	   (@IdEst14, '2023-08-12', '2024-09-01', 'REV'),
	   (@IdEst14, '2023-09-02', '2023-10-01', 'REV'),
	   (@IdEst14, '2023-10-03', '2023-11-01', 'REV'),
	   (@IdEst14, '2023-11-07', '2024-01-01', 'APR'),
	   (@IdEst14, '2024-01-02', '2024-04-01', 'APR'),
	   (@IdEst14, '2024-04-04', '2024-07-01', 'APR');


--Licencias para EST 15:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst15, '2023-01-01', '2023-03-01', 'APR'),
	   (@IdEst15, '2023-03-02', '2023-04-01', 'REV'),
	   (@IdEst15, '2023-04-03', '2023-07-01', 'APR'),
	   (@IdEst15, '2023-07-02', '2023-08-01', 'REV'),
	   (@IdEst15, '2023-08-06', '2023-10-01', 'APR'),
	   (@IdEst15, '2023-10-02', '2023-11-01', 'REV'),
	   (@IdEst15, '2023-11-02', '2023-12-01', 'REV'),
	   (@IdEst15, '2023-12-01', '2024-03-01', 'APR'),
	   (@IdEst15, '2024-03-02', '2024-06-01', 'APR');


--Licencias para EST 16:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst16, '2023-05-19', '2023-08-01', 'APR'),
	   (@IdEst16, '2023-08-06', '2023-11-01', 'APR'),
	   (@IdEst16, '2023-11-07', '2024-02-01', 'APR'),
	   (@IdEst16, '2024-02-03', '2024-05-01', 'APR'),
	   (@IdEst16, '2024-05-03', '2024-08-01', 'APR');


--Licencias para EST 17:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst17, '2023-02-16', '2023-04-01', 'APR'),
	   (@IdEst17, '2023-04-22', '2023-07-01', 'APR'),
	   (@IdEst17, '2023-07-05', '2023-08-01', 'REV'),
	   (@IdEst17, '2023-08-02', '2023-10-01', 'APR'),
	   (@IdEst17, '2023-10-03', '2024-01-01', 'APR'),
	   (@IdEst17, '2024-01-05', '2024-02-01', 'REV'),
	   (@IdEst17, '2024-02-05', '2024-05-01', 'APR');


--Licencias para EST 18:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst18, '2022-12-14', '2023-03-01', 'APR'),
	   (@IdEst18, '2023-03-02', '2023-04-01', 'REV'),
	   (@IdEst18, '2023-04-08', '2023-06-01', 'APR'),
	   (@IdEst18, '2023-06-04', '2023-09-01', 'APR'),
	   (@IdEst18, '2023-09-02', '2023-12-01', 'APR'),
	   (@IdEst18, '2023-12-07', '2024-03-01', 'APR'),
	   (@IdEst18, '2024-03-06', '2024-04-01', 'REV'),
	   (@IdEst18, '2024-04-02', '2024-07-01', 'APR');


--Licencias para EST 19:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst19, '2023-01-15', '2023-02-01', 'REV'),
	   (@IdEst19, '2023-02-01', '2023-04-01', 'APR'),
	   (@IdEst19, '2023-04-05', '2023-07-01', 'APR'),
	   (@IdEst19, '2023-07-02', '2023-08-01', 'REV'),
	   (@IdEst19, '2023-08-01', '2023-11-01', 'APR'),
	   (@IdEst19, '2023-11-05', '2024-02-01', 'APR'),
	   (@IdEst19, '2024-02-05', '2024-04-01', 'APR'),
	   (@IdEst19, '2024-04-02', '2024-07-01', 'APR');


--Licencias para EST 20:
INSERT INTO Licencias (estNumero, licFchEmision, licFchVto, licStatus) 
VALUES (@IdEst20, '2023-02-22', '2023-04-01', 'APR'),
	   (@IdEst20, '2023-04-09', '2023-06-01', 'APR'),
	   (@IdEst20, '2023-06-03', '2023-07-01', 'REV'),
	   (@IdEst20, '2023-07-02', '2023-10-01', 'APR'),
	   (@IdEst20, '2023-10-12', '2023-12-01', 'APR'),
	   (@IdEst20, '2023-12-07', '2024-03-01', 'APR'),
	   (@IdEst20, '2024-03-05', '2024-06-01', 'APR'),
	   (@IdEst20, '2024-06-05', '2024-09-01', 'APR');





/*

FIN PRECARGA
Testeo general:
*/

/*
SELECT * FROM Establecimientos
SELECT * FROM TipoViolacion
SELECT * FROM Inspecciones
SELECT * FROM Licencias
*/

--Inspecciones de cada Establecimiento - TESTEO. / Cambiar el ID manualmente para no repetir excesivamente código.
/*SELECT insp.*
FROM Inspecciones insp
WHERE insp.estNumero = 1;*/

--Licencias de cada Establecimiento - TESTEO. / Cambiar el ID manualmente para no repetir excesivamente código.
/*SELECT lic.*
FROM Licencias lic
WHERE lic.estNumero = 1;*/
