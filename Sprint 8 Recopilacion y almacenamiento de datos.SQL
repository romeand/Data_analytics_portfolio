1 Escribe un código para analizar los datos sobre el clima en Chicago en noviembre de 2017 desde el sitio web:
[https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html)
El nombre del DataFrame debe ser weather_records y tienes que especificarlo cuando buscas: attrs={"id": "weather_records"} . Imprime el DataFrame completo.

import pandas as pd
import requests
from bs4 import BeautifulSoup
URL = 'https://practicum-content.s3.us-west-1.amazonaws.com/data-analyst-eng/moved_chicago_weather_2017.html'
req = requests.get(URL)
soup = BeautifulSoup(req.text, 'lxml')
table = soup.find('table', attrs={"id":"weather_records"})
heading_table=[]
for row in table.find_all('th'):
    heading_table.append(row.text)
content=[]
for row in table.find_all('tr'):
    if not row.find_all('th'):
        content.append([element.text for element in row.find_all('td')])
weather_records = pd.DataFrame(content,columns = heading_table)
print(weather_records)

Resultado
           Date and time Temperature       Description
0    2017-11-01 00:00:00     276.150     broken clouds
1    2017-11-01 01:00:00     275.700  scattered clouds
2    2017-11-01 02:00:00     275.610   overcast clouds
3    2017-11-01 03:00:00     275.350     broken clouds
4    2017-11-01 04:00:00     275.240     broken clouds
5    2017-11-01 05:00:00     275.050   overcast clouds
6    2017-11-01 06:00:00     275.140   overcast clouds
7    2017-11-01 07:00:00     275.230   overcast clouds
8    2017-11-01 08:00:00     275.230   overcast clouds
9    2017-11-01 09:00:00     275.320   overcast clouds
10   2017-11-01 10:00:00     275.230   overcast clouds
11   2017-11-01 11:00:00     275.510   overcast clouds
12   2017-11-01 12:00:00     275.690   overcast clouds
13   2017-11-01 13:00:00     275.790   overcast clouds
14   2017-11-01 14:00:00     275.850     broken clouds

1 al 6
1 al 3 exploratorio y 4-6 prueba hipotesis.

1.Imprime el campo company_name. Encuentra la cantidad de viajes en taxi para cada compañía de taxis para el 15 y 16 de noviembre de 2017, asigna al campo resultante el nombre trips_amount e imprímelo también. Ordena los resultados por el campo trips_amount en orden descendente.

CONSEJO Junta las tablas cabs y trips. Utiliza funciones de agregación y agrupación. No olvides introducir una condición.
Las primeras filas de la tabla resultante deberían ser así:

company_name	trips_amount
Flash Cab	19558
Taxi Affiliation Services	11422

SELECT
    cabs.company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM
    cabs
    INNER JOIN
    trips
    ON
    trips.cab_id = cabs.cab_id
where
    CAST(trips.start_ts AS date) BETWEEN '2017-11-15' AND '2017-11-16'
GROUP by
    company_name
ORDER by
    trips_amount DESC;

Resultado
company_name	trips_amount
Flash Cab	19558
Taxi Affiliation Services	11422
Medallion Leasin	10367
Yellow Cab	9888
Taxi Affiliation Service Yellow	9299

2.Encuentra la cantidad de viajes para cada empresa de taxis cuyo nombre contenga las palabras "Yellow" o "Blue" del 1 al 7 de noviembre de 2017. 
Nombra la variable resultante trips_amount. Agrupa los resultados por el campo company_name.

CONSEJO

Junta las tablas cabs y trips. Puedes hacer cálculos para un grupo de empresas (por ejemplo, aquellas cuyo nombre contiene la palabra "Yellow"), luego para el otro y finalmente agrupar los resultados.

El resultado final debería tener este aspecto:

company_name	trips_amount
Taxi Affiliation Service Yellow	29213
Yellow Cab	33668
Blue Diamond	6764
Blue Ribbon Taxi Association Inc.	17675

SELECT
    cabs.company_name as company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
INNER JOIN 
    trips 
ON 
    trips.cab_id = cabs.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
    AND cabs.company_name LIKE '%%Yellow%%'
GROUP BY company_name
UNION ALL
SELECT
    cabs.company_name as company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM 
    cabs
INNER JOIN 
    trips 
ON 
    trips.cab_id = cabs.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
    AND cabs.company_name LIKE '%%Blue%%'
GROUP BY company_name;

Resultado
company_name	trips_amount
Taxi Affiliation Service Yellow	29213
Yellow Cab	33668
Blue Diamond	6764
Blue Ribbon Taxi Association Inc.	17675


3.Del 1 al 7 de noviembre de 2017, las empresas de taxis más populares fueron Flash Cab y Taxi Affiliation Services.
 Encuentra el número de viajes de estas dos empresas y asigna a la variable resultante el nombre trips_amount. Junta los viajes de todas las demás empresas en el grupo "Other". 
 Agrupa los datos por nombres de empresas de taxis. 
Asigna el nombre company al campo con nombres de empresas de taxis. Ordena el resultado en orden descendente por trips_amount.

CONSEJO

Junta las tablas cabs y trips. Utiliza la construcción CASE para agrupar las empresas.

El resultado final debería tener este aspecto:

company	trips_amount
Other	335771
Flash Cab	64084
Taxi Affiliation Services	37583

SELECT
    CASE 
        WHEN company_name = 'Flash Cab' THEN 'Flash Cab' 
        WHEN company_name = 'Taxi Affiliation Services' THEN 'Taxi Affiliation Services' 
        ELSE 'Other' 
    END AS company,
    COUNT(trips.trip_id) as trips_amount                
FROM 
    cabs
INNER JOIN 
    trips 
ON 
    trips.cab_id = cabs.cab_id
WHERE 
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01' AND '2017-11-07'
GROUP BY 
    company
ORDER BY 
    trips_amount DESC;

Resultado
company	trips_amount
Other	335771
Flash Cab	64084
Taxi Affiliation Services	37583


4.Recupera los identificadores de los barrios de OHare y Loop de la tabla neighborhoods.

Utiliza la condición name LIKE '%Hare' OR name LIKE 'Loop'

El resultado final debería tener este aspecto:

neighborhood_id	name
50	Loop
63	OHare

CONSEJO 
Utiliza la condición name LIKE '%Hare' OR name LIKE 'Loop'

El resultado final debería tener este aspecto:

neighborhood_id	name
50	Loop
63	OHare

SELECT
    neighborhoods.name AS name,
    neighborhoods.neighborhood_id
FROM
    neighborhoods
WHERE 
    name LIKE '%Hare' OR name LIKE 'Loop'
GROUP by
    neighborhood_id,
    name;

Resultado
name	neighborhood_id
Loop	50
O'Hare	63




