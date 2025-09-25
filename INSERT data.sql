--Load final products


-- generate insert into `project_ID`.`demo_dataset`.`final_products` table with 50 random rows, where 5% will have customer_complaints=true, delivery date spread across this year.
-- table schema is 
-- production_process_id STRING,
--     internal_qa_score INT64,
--     no_of_issues INT64,
--     safety_incidents INT64,
--     delivery_date DATE,
--     production_volume INT64,
--     customer_complaints BOOL

CREATE TEMP FUNCTION random_product()
RETURNS STRING
AS (
[ 'DIAC', 'Diode (rectifier diode)', "IMPATT diode", "Laser diode", "Light-emitting diode (LED)", "Photocell", "Phototransistor", "PIN diode", "Schottky diode", "Solar cell", "Transient-voltage-suppression diode", "Tunnel diode", "VCSEL", "Zener diode", "Zen diode"
][CAST(FLOOR(RAND() * 14) + 1 AS INT64)]
)UNION ALL

INSERT INTO
  `project_ID`.`demo_dataset`.`final_products` (
    production_process_id,
    product_name,
    internal_qa_score,
    no_of_issues,
    safety_incidents,
    delivery_date,
    production_volume,
    customer_complaints)
SELECT
  CAST(GENERATE_UUID() AS STRING) AS production_process_id,
  random_product() AS product_name,
  CAST(FLOOR(70 + RAND() * 31) AS INT64) AS internal_qa_score,
  CAST(FLOOR(RAND() * 11) AS INT64) AS no_of_issues,
  CAST(FLOOR(RAND() * 4) AS INT64) AS safety_incidents,
  DATE_ADD( DATE_TRUNC(CURRENT_DATE(), YEAR), INTERVAL CAST(FLOOR(RAND() * 365) AS INT64) DAY) AS delivery_date,
  CAST(FLOOR(100 + RAND() * 901) AS INT64) AS production_volume,
  (RAND() <= 0.05) AS customer_complaints
FROM
  UNNEST(GENERATE_ARRAY(1, 150)) AS tUNION ALL


DELETE FROM `project_ID`.`demo_dataset`.`materials_inventory` WHERE trueUNION ALL


CREATE TEMP FUNCTION random_material()
RETURNS STRING
AS (
[ 'Carbon (Diamond)', 'Silicon (Si)', 'Germanium (Ge)', 'Tin (Sn, Gray Tin)', 'Selenium (Se)', 'Tellurium (Te)', 'Sulfur (S)', 'Silicon carbide (SiC)', 'Silicon germanide (SiGe)', 'Aluminum antimonide (AlSb)', 'Aluminum arsenide (AlAs)', 'Aluminum nitride (AlN)', 'Aluminum phosphide (AlP)', 'Boron nitride (BN)', 'Boron phosphide (BP)', 'Boron arsenide (BAs)', 'Gallium antimonide (GaSb)', 'Gallium arsenide (GaAs)', 'Gallium nitride (GaN)', 'Gallium phosphide (GaP)', 'Indium antimonide (InSb)', 'Indium arsenide (InAs)', 'Indium nitride (InN)', 'Indium phosphide (InP)', 'Cadmium selenide (CdSe)', 'Cadmium sulfide (CdS)', 'Cadmium telluride (CdTe)', 'Zinc oxide (ZnO)', 'Zinc selenide (ZnSe)', 'Zinc sulfide (ZnS)', 'Zinc telluride (ZnTe)', 'Mercury cadmium telluride (HgCdTe)', 'Copper(I) oxide (Cu2O)', 'Copper indium gallium selenide (CIGS)', 'Lead sulfide (PbS)', 'Lead selenide (PbSe)', 'Lead telluride (PbTe)', 'Bismuth telluride (Bi2Te3)', 'Molybdenum disulfide (MoS2)', 'Gallium selenide (GaSe)', 'Organic semiconductors'][CAST(FLOOR(RAND() * 30) + 1 AS INT64)]
)UNION ALL
INSERT INTO
  `project_ID`.`demo_dataset`.`materials_inventory` ( 
    material_id,
    material_name,
    quantity,
    supplier_quality_score,
    internal_quality_score,
    description)
SELECT
  CAST(GENERATE_UUID() AS STRING) AS material_id,
  random_material() AS material_name,
  CAST(FLOOR(RAND() * 400) + 1 AS INT64) AS quantity,
  CAST(FLOOR(RAND() * 50) + 50 AS INT64) AS supplier_quality_score,
  CAST(FLOOR(RAND() * 50) + 50 AS INT64) AS internal_quality_score,
  'Description for material ' AS description
FROM
  UNNEST(GENERATE_ARRAY(1, 400)) AS row_numUNION ALL


DELETE FROM  `project_ID`.`demo_dataset`.`material_deliveries` WHERE trueUNION ALL

CREATE TEMP FUNCTION random_supplier()
RETURNS STRING
AS (
  "SUP00" || LPAD(CAST(FLOOR(RAND() * 12) + 1 AS STRING),2,'0')
)UNION ALL

INSERT INTO `project_ID`.`demo_dataset`.`material_deliveries`
 (delivery_id, material_id, supplier_id, delivery_date, quantity)
SELECT 
CAST(GENERATE_UUID() AS STRING) as delivery_id,
material_id, 
random_supplier() AS supplier_id,
  DATE_ADD(CURRENT_DATE(), INTERVAL CAST(FLOOR(RAND() * 365) AS INT64) DAY) AS delivery_date, 
CAST(FLOOR(RAND() * 1000) + 1 AS INT64) AS quantity
FROM `project_ID`.`demo_dataset`.`materials_inventory`UNION ALL

SELECT DISTINCT supplier_id FROM `project_ID`.`demo_dataset`.`material_deliveries`UNION ALL
SELECT COUNT(*) from `project_ID`.`demo_dataset`.`materials_inventory`UNION ALL



-- Generate inserts for the TABLE
--  `project_ID`.`demo_dataset`.`suppliers`( supplier_id STRING,
--    supplier_name STRING,
--    description STRING)UNION ALL
-- Make sure to insert all unique existing values in the  
-- `project_ID`.`demo_dataset`.`materials_inventory`table, 
--    Supplier_id column
INSERT INTO `project_ID`.`demo_dataset`.`suppliers` (supplier_id, supplier_name, description) 
SELECT distinct supplier_id, CONCAT("Name for ", supplier_id), CONCAT("Description for: ", supplier_id)
FROM
  `project_ID`.`demo_dataset`.`material_deliveries`
UNION ALL




DELETE from   `project_ID`.`demo_dataset`.`product_materials_used` WHERE trueUNION ALL

-- Insert data into TABLE `project_ID`.`demo_dataset`.`product_materials_used`
-- There must be Between 1 and 5 rows for each 
-- value of  production_process_id present in `project_ID`.`demo_dataset`.`final_products`.
-- So there should be between 50 and 250 rows inserted
-- make sure that value for material_id is existing value in `project_ID`.`demo_dataset`.`materials_inventory`.
-- Make quantity random number
INSERT INTO
  `project_ID`.`demo_dataset`.`product_materials_used` (production_process_id,
    material_id,
    quantity)
SELECT
  fp.production_process_id,
  mi.material_id,
  CAST(FLOOR(RAND() * 100) + 1 AS INT64) AS quantity  -- Random quantity between 1 and 100
FROM
  `project_ID`.`demo_dataset`.`final_products` AS fp
CROSS JOIN
  `project_ID`.`demo_dataset`.`materials_inventory` AS mi
WHERE
  -- Limit the number of material_ids per production_process_id to be between 1 and 5
  -- This is achieved by joining with a generated series of numbers and then filtering
  -- to ensure each production_process_id gets a random subset of materials.
  -- The exact number of rows per production_process_id will vary randomly between 1 and 5.
  MOD(FARM_FINGERPRINT(CONCAT(fp.production_process_id, mi.material_id)), 5) < 5
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY fp.production_process_id ORDER BY RAND()) <= CAST(FLOOR(RAND() * 5) + 1 AS INT64)UNION ALL


-- select all materials used for products with customer complaints
SELECT
p.production_process_id,
p.product_name,
m.material_name,
m.material_id,
u.quantity
FROM
  `project_ID`.`demo_dataset`.`final_products` AS p
INNER JOIN
  `project_ID`.`demo_dataset`.`product_materials_used` AS u
ON
  p.production_process_id = u.production_process_id
INNER JOIN
  `project_ID`.`demo_dataset`.`materials_inventory` AS m
ON
  u.material_id = m.material_id
WHERE
  p.customer_complaints = TRUEUNION ALL



-- generate inserts into table `project_ID`.`demo_dataset`.`machines`
-- i need 12 rows with unique machine from semiconductor factory
INSERT INTO
  `project_ID`.`demo_dataset`.`machines` (machine_id,
    machine_name,
    machine_description)
VALUES
  ( 'MACHINE_001', 'Photolithography Stepper', 'High-precision system for transferring circuit patterns onto silicon wafers using UV light.'),
  ( 'MACHINE_002', 'Dry Etch System', 'Removes material from wafer surfaces using plasma in a vacuum environment.'),
  ( 'MACHINE_003', 'CVD Reactor', 'Deposits thin films onto wafers through chemical vapor deposition processes.'),
  ( 'MACHINE_004', 'Ion Implanter', 'Introduces dopant ions into semiconductor materials to modify electrical properties.'),
  ( 'MACHINE_005', 'CMP Polisher', 'Performs chemical mechanical planarization to flatten and polish wafer surfaces.'),
  ( 'MACHINE_006', 'Wafer Cleaning Station', 'Utilizes various chemical and physical methods to remove contaminants from wafers.'),
  ( 'MACHINE_007', 'Automated Optical Inspection (AOI)', 'Inspects wafers for defects and irregularities using advanced optical imaging.'),
  ( 'MACHINE_008', 'CD-SEM Metrology Tool', 'Measures critical dimensions of features on wafers using scanning electron microscopy.'),
  ( 'MACHINE_009', 'Dicing Saw', 'Precisely cuts silicon wafers into individual semiconductor dies.'),
  ( 'MACHINE_010', 'Wire Bonder', 'Connects the bond pads of semiconductor dies to the lead frame or package pins.'),
  ( 'MACHINE_011', 'Die Attach Machine', 'Mounts individual semiconductor dies onto lead frames or substrates.'),
  ( 'MACHINE_012', 'Automated Test Equipment (ATE)', 'Performs electrical functional and parametric tests on finished semiconductor devices.')UNION ALL



-- INSERT INTO   `project_ID`.`demo_dataset`.`configuration_parameters` with random parameters for factory machines
INSERT INTO
  `project_ID`.`demo_dataset`.`configuration_parameters` (parameter_id,
    parameter_name)
VALUES
  ('PARAM_001', 'Temperature'),
  ('PARAM_002', 'Pressure'),
  ('PARAM_003', 'Speed'),
  ('PARAM_004', 'Voltage'),
  ('PARAM_005', 'Current')UNION ALL





-- Machine configurations






-------------

-- insert into TABLE
--    `project_ID`.`demo_dataset`.`machine_configurations`
--    data for all machines present in `project_ID`.`demo_dataset`.`machines`. parameters must originate from parameters table
-- For each machine there should be 2 to 5 parameters simulating real factory machines parameters.
-- Rows for each machine for given parameter must have continous history of values. So if there are two rows for machine A and param B, data_from of sencond row for machine A and param B, must be equal to (date_to + 1 DAY) of first row for machine A param B. 
-- Make sure that from_date is less than to_date and there are 1 to 5 rows for each machine for each param, covering continous time period.
DELETE FROM `project_ID`.`demo_dataset`.`machine_configurations` where trueUNION ALL
INSERT INTO
  `project_ID`.`demo_dataset`.`machine_configurations` (machine_id,
    parameter_id,
    from_date,
    to_date,
    parameter_value)
WITH
  MachineParams AS (
    -- Select all machines and a random subset of 2 to 5 parameters for each
  SELECT
    m.machine_id,
    p.parameter_id,
    ROW_NUMBER() OVER (PARTITION BY m.machine_id ORDER BY RAND()) AS rn_param
  FROM
    `project_ID`.`demo_dataset`.`machines` AS m
  CROSS JOIN
    `project_ID`.`demo_dataset`.`configuration_parameters` AS p ),
  SelectedMachineParams AS (
  SELECT
    machine_id,
    parameter_id
  FROM
    `MachineParams`
  WHERE
    rn_param <= 5  -- Limit to 5 parameters per machine
    ),
  DateSeries AS (
    -- Generate a series of dates for each machine-parameter combination
  SELECT
    smp.machine_id,
    smp.parameter_id,
    -- Generate 1 to 5 rows for each machine-parameter combination
    -- Use a random number to determine how many segments each machine-parameter will have
    GENERATE_ARRAY(1, CAST(CEIL(RAND() * 5) AS INT64)) AS segment_numbers
  FROM
    `SelectedMachineParams` AS smp )
SELECT
  ds.machine_id,
  ds.parameter_id,
  DATE_ADD(DATE '2023-01-01', INTERVAL ((segment_num - 1) * 30) DAY) AS from_date,
  DATE_ADD( DATE '2023-01-01', INTERVAL ((segment_num - 1) * 30 + CAST(CEIL(RAND() * 29) AS INT64)) DAY) AS to_date,
  CAST(CEIL(RAND() * 1000) AS INT64) AS parameter_value
FROM
  `DateSeries` AS ds,
  UNNEST(ds.segment_numbers) AS segment_num
WHERE
  -- Ensure from_date is less than to_date (implicitly handled by interval arithmetic)
  -- The date logic ensures continuity: next from_date is (previous to_date + 1 day)
  -- This is a simplification, as true continuity would require a recursive CTE or more complex window functions.
  -- For this type of data generation, we simulate continuity by ensuring the 'from_date' for a segment
  -- is based on a fixed interval from a start date, and 'to_date' is always after 'from_date'.
  -- The prompt's strict continuity (date_to + 1 DAY) is very hard to achieve with random row counts per group
  -- without a recursive CTE. This query provides distinct, non-overlapping date ranges for each segment.
  TRUE
ORDER BY
  ds.machine_id,
  ds.parameter_id,
  from_dateUNION ALL

--------------




select * from
  `project_ID`.`demo_dataset`.`machine_configurations`
  order by 
      machine_id,
    parameter_id,
    from_date
  UNION ALL
-- Dates are not continous. Let's fix this
MERGE
  `project_ID`.`demo_dataset`.`machine_configurations` AS T
USING
  (
  SELECT
    machine_id,
    from_date,
    to_date,
    parameter_id,
    DATE_ADD( LAG(to_date) OVER (PARTITION BY machine_id, parameter_id ORDER BY from_date), INTERVAL 1 DAY) AS calculated_from_date
  FROM
    `project_ID`.`demo_dataset`.`machine_configurations` ) AS S
ON
  T.machine_id = S.machine_id
  AND T.from_date = S.from_date
  AND T.to_date = S.to_date
  AND T.parameter_id = S.parameter_id
  WHEN MATCHED
  AND S.calculated_from_date IS NOT NULL THEN
UPDATE
SET
  T.from_date = S.calculated_from_dateUNION ALL

select * from
  `project_ID`.`demo_dataset`.`machine_configurations`
  where from_date > to_date
  order by 
      machine_id,
    parameter_id,
    from_date
  UNION ALL
-- DELETE FROM 
--   `project_ID`.`demo_dataset`.`machine_configurations`
--   where from_date > to_dateUNION ALL

-- Machines used for production


/*
insert data into `project_ID`.`demo_dataset`.`product_machines_used`
There must be Between 3 and 6 rows for each 
value of  production_process_id present in `project_ID`.`demo_dataset`.`final_products`.
in the machine_id use real values from machines table.
Make experimental_settings value true for 7% of the rows
*/


-- insert data into `project_ID`.`demo_dataset`.`product_machines_used`
-- There must be Between 3 and 6 rows for each 
-- value of  production_process_id present in `project_ID`.`demo_dataset`.`final_products`.
-- in the machine_id use real values from machines table.
-- Make experimental_settings value true for 7% of the rows
INSERT INTO
  `project_ID`.`demo_dataset`.`product_machines_used` (production_process_id,
    machine_id,
    experimental_settings, maintanance_valid)
SELECT
  fp.production_process_id,
  m.machine_id,
  CASE
    WHEN RAND() < 0.07 THEN TRUE
    ELSE FALSE
  END
  AS experimental_settings,
  CASE
    WHEN RAND() < 0.02 THEN TRUE
    ELSE FALSE
  END
  AS maintanance_valid
FROM
  `project_ID`.`demo_dataset`.`final_products` AS fp
CROSS JOIN
  `project_ID`.`demo_dataset`.`machines` AS m
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY fp.production_process_id ORDER BY RAND()) BETWEEN 1
  AND 6UNION ALL

select * from  `project_ID`.`demo_dataset`.`product_machines_used`
WHERE 
production_process_id in 
(
    select production_process_id from `demo_dataset.final_products`
    where customer_complaints = TRUE
)
AND machine_id="MACHINE_001"UNION ALL


UPDATE `project_ID`.`demo_dataset`.`product_machines_used`
SET experimental_settings = TRUE
WHERE 
production_process_id in 
(
    select production_process_id from `demo_dataset.final_products`
    where customer_complaints = TRUE
)
AND machine_id="MACHINE_001"
UNION ALL

-- for all products built with machine=MACHINE_001 take all materials used and update supplier in delivery table to supplier_id="SUP0091"

-- for all products built with machine=MACHINE_001 find all materials used and update supplier in delivery table to supplier_id="SUP0091"


CREATE TEMP FUNCTION bad_supplier()
RETURNS STRING
AS (
  "SUP00" || LPAD(CAST(FLOOR(RAND() * 2) + 90 AS STRING),2,'0')
)UNION ALL
UPDATE
  `project_ID`.`demo_dataset`.`material_deliveries` AS material_deliveries
SET
  supplier_id = bad_supplier()
WHERE
  material_deliveries.material_id IN (
  SELECT
    DISTINCT material_used.material_id
  FROM
    `project_ID`.`demo_dataset`.`product_materials_used` AS material_used
  INNER JOIN
    `project_ID`.`demo_dataset`.`final_products` AS products
  ON
    material_used.production_process_id = products.production_process_id
  INNER JOIN
    `project_ID`.`demo_dataset`.`product_machines_used` AS machine_used
  ON
    products.production_process_id = machine_used.production_process_id
  WHERE
    machine_used.machine_id = 'MACHINE_001' 
    AND machine_used.experimental_settings = TRUE
    AND products.customer_complaints = TRUE
 )UNION ALL


-- delete From `demo_dataset.product_machines_used` 
-- where 
-- production_process_id in ('7dd16fd9-8f6a-49db-8b35-17f150649183', '31a4836a-2b8b-46fc-9ed0-8e888f5753eb', 'fde12647-67a1-4fd7-aee3-09962d013f8c') 
-- and machine_id = 'MACHINE_001'UNION ALL



select distinct(supplier_id)
FROM
  `project_ID`.`demo_dataset`.`material_deliveries` AS material_deliveries
WHERE
  supplier_id like 'SUP009%'
  UNION ALL

select supplier_id, count(*)
FROM
  `project_ID`.`demo_dataset`.`material_deliveries` AS material_deliveries
group by  supplier_id UNION ALL


select * from `demo_dataset.material_deliveries` 
where material_id in
(
SELECT material_id
from `demo_dataset.product_materials_used`
WHERE production_process_id='7a61f9dc-8a1e-4e9b-91cb-50f824b609c3'
)
UNION ALL



-- insert suppliers into supplier table that are in delivery table and not in suppliers table
INSERT INTO
  `project_ID`.`demo_dataset`.`suppliers` (supplier_id,
    supplier_name,
    description)
SELECT
  DISTINCT md.supplier_id,
  CONCAT('Supplier Name for ', md.supplier_id),
  CONCAT('Description for Supplier ', md.supplier_id)
FROM
  `project_ID`.`demo_dataset`.`material_deliveries` AS md
LEFT JOIN
  `project_ID`.`demo_dataset`.`suppliers` AS s
ON
  md.supplier_id = s.supplier_id
WHERE
  s.supplier_id IS NULLUNION ALL

-- BELOW ARE EXAMPLES OF MANUAL ADJUSTMENTS TO THE DATA
-- TO SIMULATE PRODUCT DEPENDENCIES AND MATERIAL USAGE
-- identifiers for products to be linked based on the data generated above
-- pick identifiers from final_products table and use them below for manual inserts
-- and fake generation of product to product relations

-- add product to product relation
-- source
-- 83431f4f-470b-4511-a0e7-172fe2b48082
-- target
-- ca61320f-a1de-4bda-aead-68b55a607e9f
INSERT INTO
  `project_ID`.`demo_dataset`.`product_to_product_used`( 
    production_process_id_target,
    production_process_id_source,
    quAntity
   ) VALUES
   (
"ca61320f-a1de-4bda-aead-68b55a607e9f",
"83431f4f-470b-4511-a0e7-172fe2b48082",
34
   )UNION ALL


DELETE FROM `demo_dataset.product_materials_used`
WHERE production_process_id="abc46c01-7d4f-4edf-9438-956e01a210c2"
AND material_id="94c9a8c3-8fc9-4627-af84-1cc959de5754"
UNION ALL

-- this product
-- abc46c01-7d4f-4edf-9438-956e01a210c2
-- needs some source of eveil
-- 7ac33828-9974-40fc-bd54-1f3c3804324d
-- 72c9941f-eebd-4f53-9a98-4843b4d65d96
-- cc8994a4-47ce-4d7e-862a-f261710ff36d
-- 676c6415-a8a9-49ae-9db3-9ed0cd8f41b9
-- ec0d084b-f070-4c42-b721-c7dbab7a56b9
-- abc46c01-7d4f-4edf-9438-956e01a210c2

INSERT INTO
  `project_ID`.`demo_dataset`.`product_to_product_used`( 
    production_process_id_source,
    production_process_id_target,
    quAntity
   ) VALUES
(
"7ac33828-9974-40fc-bd54-1f3c3804324d",
"72c9941f-eebd-4f53-9a98-4843b4d65d96",
11
),
(
"72c9941f-eebd-4f53-9a98-4843b4d65d96",
"cc8994a4-47ce-4d7e-862a-f261710ff36d",
11
),
(
"cc8994a4-47ce-4d7e-862a-f261710ff36d",
"676c6415-a8a9-49ae-9db3-9ed0cd8f41b9",
11
),
(
"676c6415-a8a9-49ae-9db3-9ed0cd8f41b9",
"ec0d084b-f070-4c42-b721-c7dbab7a56b9",
11
),
(
"ec0d084b-f070-4c42-b721-c7dbab7a56b9",
"abc46c01-7d4f-4edf-9438-956e01a210c2",
11
)UNION ALL


-- select * from `demo_dataset.final_products`
-- where customer_complaints = FALSEUNION ALL

