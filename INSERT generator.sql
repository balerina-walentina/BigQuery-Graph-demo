SELECT
  FORMAT(INSERT INTO `demo_dataset.machines` (machine_id, machine_name, machine_description) VALUES ('%s', '%s', '%s');,
    t.machine_id, `REPLACE`(t.machine_name, "'", "''"), `REPLACE`(t.machine_description, "'", "''")) AS insert_statement
FROM
  `project_ID`.factory_data_extended.machines AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.product_machines_used` (production_process_id, machine_id, experimental_settings, maintanance_valid) VALUES ('%s', '%s', %t, %t);,
    t.production_process_id, t.machine_id, t.experimental_settings, t.maintanance_valid) AS insert_statement
FROM
  `project_ID`.factory_data_extended.product_machines_used AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.suppliers` (supplier_id, supplier_name, description) VALUES ('%s', '%s', '%s');,
    t.supplier_id, `REPLACE`(t.supplier_name, "'", "''"), `REPLACE`(t.description, "'", "''")) AS insert_statement
FROM
  `project_ID`.factory_data_extended.suppliers AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.final_products` (production_process_id, product_name, internal_qa_score, no_of_issues, safety_incidents, delivery_date, production_volume, customer_complaints) VALUES ('%s', '%s', %d, %d, %d, '%s', %d, %t);,
    t.production_process_id, `REPLACE`(t.product_name, "'", "''"), t.internal_qa_score, t.no_of_issues, t.safety_incidents,
    FORMAT_DATE('%Y-%m-%d', t.delivery_date), t.production_volume, t.customer_complaints) AS insert_statement
FROM
  `project_ID`.factory_data_extended.final_products AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.material_deliveries` (delivery_id, material_id, supplier_id, delivery_date, quantity) VALUES ('%s', '%s', '%s', '%s', %d);,
    t.delivery_id, t.material_id, t.supplier_id, FORMAT_DATE('%Y-%m-%d', t.delivery_date), t.quantity) AS insert_statement
FROM
  `project_ID`.factory_data_extended.material_deliveries AS t
UNION ALL

-- generate this statement for following tables in the factory_data_extended dataset:
-- configuration_parameters
-- materials_inventory
-- machine_configurations
-- product_materials_used
-- product_to_product_used

SELECT
  FORMAT(INSERT INTO `demo_dataset.configuration_parameters` (parameter_id, parameter_name) VALUES ('%s', '%s');,
    t.parameter_id, `REPLACE`(t.parameter_name, "'", "''")) AS insert_statement
FROM
  `project_ID`.factory_data_extended.configuration_parameters AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.machine_configurations` (machine_id, parameter_id, from_date, to_date, parameter_value) VALUES ('%s', '%s', '%s', '%s', %d);,
    t.machine_id, t.parameter_id, FORMAT_DATE('%Y-%m-%d', t.from_date), FORMAT_DATE('%Y-%m-%d', t.to_date),
    t.parameter_value) AS insert_statement
FROM
  `project_ID`.factory_data_extended.machine_configurations AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.product_materials_used` (production_process_id, material_id, quantity) VALUES ('%s', '%s', %d);,
    t.production_process_id, t.material_id, t.quantity) AS insert_statement
FROM
  `project_ID`.factory_data_extended.product_materials_used AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.product_to_product_used` (production_process_id_target, production_process_id_source, quantity) VALUES ('%s', '%s', %d);,
    t.production_process_id_target, t.production_process_id_source, t.quantity) AS insert_statement
FROM
  `project_ID`.factory_data_extended.product_to_product_used AS t
UNION ALL
SELECT
  FORMAT(INSERT INTO `demo_dataset.materials_inventory` (material_id, material_name, quantity, supplier_quality_score, internal_quality_score, description) VALUES ('%s', '%s', %d, %d, %d, '%s');,
    t.material_id, `REPLACE`(t.material_name, "'", "''"), t.quantity, t.supplier_quality_score, t.internal_quality_score,
    `REPLACE`(t.description, "'", "''")) AS insert_statement
FROM
  `project_ID`.factory_data_extended.materials_inventory AS t
;