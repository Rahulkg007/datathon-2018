-- Extract data for specific stops
SELECT * FROM `melbourne-datathon-211508.source.stop_locations` where lower(StopNameLong) like lower('%West%Preston%')

-- Tram 11 stops

SELECT
  StopNameLong
FROM
  `melbourne-datathon-211508.source.stop_locations`
WHERE
  StopLocationID IN (
  SELECT
    DISTINCT StopID
  FROM
    `melbourne-datathon-211508.source.scan_on`
  WHERE
    RouteID = 17669 )
    order by StopNameLong

-- For GIS

SELECT ST_GeogPoint(GPSLong, GPSLat) as WKT,
1000 as population
FROM `melbourne-datathon-211508.staging.scan_on_tram11`

-- Join all tables
SELECT
  scan.Mode,
  scan.BusinessDate,
  scan.DateTime,
  scan.CardID,
  scan.CardType,
  card.Card_SubType_Desc,
  card.Payment_Type,
  card.Fare_Type,
  card.Concession_Type,
  card.MI_Card_Group,
  scan.VehicleID,
  scan.ParentRoute,
  scan.RouteID,
  scan.StopID,
  stop.StopNameShort,
  stop.StopType,
  stop.SuburbName,
  stop.PostCode,
  stop.RegionName,
  stop.LocalGovernmentArea,
  stop.StatDivision,
  stop.GPSLat,
  stop.GPSLong
FROM
  `melbourne-datathon-211508.source.scan_on` scan
LEFT JOIN
  `melbourne-datathon-211508.source.card_types` card
ON
  scan.CardType = card.Card_SubType_ID
LEFT JOIN
  `melbourne-datathon-211508.source.stop_locations` stop
ON
  scan.StopID = stop.StopLocationID

-- Finding for Tram 11 from conmplete dataset

SELECT
  *
FROM
  `melbourne-datathon-211508.staging.scan_on`
WHERE
  RouteID IN (
  SELECT
    DISTINCT RouteID
  FROM
    `melbourne-datathon-211508.staging.scan_on`
  WHERE
    LOWER(StopNameLong) LIKE LOWER('%14%king%william%'))
order by StopNameLong

-- Tram 16
SELECT
  *,
  16 as TramNumber
FROM
  `melbourne-datathon-211508.staging.scan_on`
WHERE
  RouteID IN (
  WITH
    shrine AS (
    SELECT
      DISTINCT RouteID
    FROM
      `melbourne-datathon-211508.staging.scan_on` shrine
    WHERE
      LOWER(StopNameLong) LIKE LOWER('%19%Shrine%Remembrance%')),
    glenferrie AS (
    SELECT
      DISTINCT RouteID
    FROM
      `melbourne-datathon-211508.staging.scan_on` shrine
    WHERE
      LOWER(StopNameLong) LIKE LOWER('%74%Glenferrie%Station%')),
    Canterbury AS (
    SELECT
      DISTINCT RouteID
    FROM
      `melbourne-datathon-211508.staging.scan_on`
    WHERE
      LOWER(StopNameLong) LIKE LOWER('%133%Canterbury%') )
  SELECT
    DISTINCT shrine.RouteID
  FROM
    shrine
  INNER JOIN
    glenferrie
  ON
    shrine.RouteID = glenferrie.RouteID
  INNER JOIN
    Canterbury
  ON
    glenferrie.RouteID = Canterbury.RouteID )
    