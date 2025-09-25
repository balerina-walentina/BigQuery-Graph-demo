-- create a dataset called demo_dataset.
-- create table final_products with fields (snake_case):
-- production process id, internal QA score, no of issues, safety incidents, delivery date, production volume, customer complaints (bool)
CREATE SCHEMA
  `project_ID`.`demo_dataset`;
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`final_products`(
    production_process_id STRING,
    product_name STRING,
    internal_qa_score INT64,
    no_of_issues INT64,
    safety_incidents INT64,
    delivery_date DATE,
    production_volume INT64,
    customer_complaints BOOL,
    PRIMARY KEY (production_process_id) NOT ENFORCED);



-- CRATEA TABLE Materials inventory table
-- with fields (snake_case):
-- Material ID
-- Supplier ID
-- name
-- quantity
-- Supplier Quality score
-- Internal quality score
-- description
-- Delivery date
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`materials_inventory`( 
    material_id STRING,
    material_name STRING,
    quantity INT64,
    supplier_quality_score INT64,
    internal_quality_score INT64,
    description STRING,
    primary key(material_id) not enforced);



-- createa table suppliers with columns (snake_case): 
-- Supplier ID
-- Supplier name
-- description
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`suppliers`( supplier_id STRING,
    supplier_name STRING,
    description STRING,
    primary key(supplier_id) not enforced);



CREATE OR REPLACE TABLE 
  `project_ID`.`demo_dataset`.`material_deliveries` ( 
    delivery_id STRING,
    material_id STRING,
    supplier_id STRING,
    delivery_date DATE,
    quantity INT64,
    primary key(material_id,supplier_id) not enforced,
    foreign key(material_id) references `project_ID`.`demo_dataset`.`materials_inventory`(material_id) not enforced,
    foreign key(supplier_id) references `project_ID`.`demo_dataset`.`suppliers`(supplier_id) not enforced
  )
;



-- create table Product-materials-used (snake_case) with two columns being FK to 
-- 
-- `project_ID`.`demo_dataset`.`final_products` column: production_process_id,
-- `project_ID`.`demo_dataset`.`materials_inventory` column:   material_id
-- and "quantity" column
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`product_materials_used`( 
    production_process_id STRING NOT NULL OPTIONS ( description = "Foreign key referencing production_process_id from final_products table"),
    material_id STRING NOT NULL OPTIONS ( description = "Foreign key referencing material_id from materials_inventory table"),
    quantity INT64 NOT NULL OPTIONS (description = "Quantity of the material used in the product"),
    primary key(production_process_id, material_id) not enforced,
    foreign key(production_process_id) references `project_ID`.`demo_dataset`.`final_products`(production_process_id) not enforced,
    foreign key(material_id) references `project_ID`.`demo_dataset`.`materials_inventory`(material_id) not enforced);




--product to product usage relation

CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`product_to_product_used`( 
    production_process_id_target STRING NOT NULL OPTIONS ( description = "FK referencing production_process_id output"),
    production_process_id_source STRING NOT NULL OPTIONS ( description = "FK referencing production_process_id input"),
    quantity INT64 NOT NULL OPTIONS (description = "Quantity of the material used in the product"),
    primary key(production_process_id_target, production_process_id_source) not enforced,
    foreign key(production_process_id_target) references `project_ID`.`demo_dataset`.`final_products`(production_process_id) not enforced,
    foreign key(production_process_id_source) references `project_ID`.`demo_dataset`.`final_products`(production_process_id) not enforced,
);




-- create table machines with columns (snake_case)
-- machine ID,
-- machine name,
-- machine description
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`machines`( machine_id STRING OPTIONS (description = "Unique identifier for the machine"),
    machine_name STRING OPTIONS (description = "Name of the machine"),
    machine_description STRING OPTIONS (description = "Description of the machine"),
    primary key(machine_id) not enforced);


-- Machine parameter dictionary
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`configuration_parameters`( 
    parameter_id STRING OPTIONS (description = "Unique identifier for the parameter"),
    parameter_name STRING OPTIONS (description = "Name of the configuration parameter"),
    primary key(parameter_id) not enforced,
);






-- Machine configurations

-- create table machine configurations with columns (snake_case)
-- Machine ID
-- From (date)
-- to (date)
-- Param name
-- Param value
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`machine_configurations`( 
    machine_id STRING OPTIONS (description = "Unique identifier for the machine"),
    parameter_id STRING OPTIONS (description = "ID of the configuration parameter"),
    from_date DATE OPTIONS (description = "Start date of the configuration validity"),
    to_date DATE OPTIONS (description = "End date of the configuration validity"),
    parameter_value INT64 OPTIONS (description = "Value of the configuration parameter"),
    primary key(machine_id, parameter_id, from_date) not enforced,
    foreign key(machine_id) references `project_ID`.`demo_dataset`.`machines`(machine_id) not enforced,
    foreign key(parameter_id) references `project_ID`.`demo_dataset`.`configuration_parameters`(parameter_id) not enforced
 );



-- Machines used for production


-- -- create table Product-machines-used (snake_case) with two columns being FK to -- -- `project_ID`.`demo_dataset`.`final_products` column: production_process_id,-- `project_ID`.`demo_dataset`.`machines` column:   machine_id. add experimental_settings column (bool)
CREATE OR REPLACE TABLE
  `project_ID`.`demo_dataset`.`product_machines_used`( 
    production_process_id STRING OPTIONS ( description = "Foreign key referencing production_process_id from final_products table"),
    machine_id STRING OPTIONS ( description = "Foreign key referencing machine_id from machines table"),
    experimental_settings BOOL,
    maintanance_valid BOOL,
    primary key(production_process_id, machine_id) not enforced,
    foreign key(production_process_id) references `project_ID`.`demo_dataset`.`final_products`(production_process_id) not enforced,
    foreign key(machine_id) references `project_ID`.`demo_dataset`.`machines`(machine_id) not enforced);







