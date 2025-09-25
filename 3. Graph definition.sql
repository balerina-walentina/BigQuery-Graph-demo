CREATE OR REPLACE PROPERTY GRAPH demo_dataset.ProductGraph02
 NODE TABLES (
   demo_dataset.final_products
     KEY (production_process_id)
     LABEL Product
     PROPERTIES (production_process_id, product_name, customer_complaints, safety_incidents),
   demo_dataset.machines
     KEY (machine_id)
     LABEL Machine
     PROPERTIES (machine_id, machine_name),
   demo_dataset.suppliers
     KEY (supplier_id)
     LABEL Supplier
     PROPERTIES (supplier_id, supplier_name),
   demo_dataset.materials_inventory
     KEY (material_id)
     LABEL Material
     PROPERTIES (material_id, material_name),
   demo_dataset.configuration_parameters
     KEY (parameter_id)
     LABEL Parameter
     PROPERTIES (parameter_id, parameter_name),
 )
 EDGE TABLES(
   demo_dataset.material_deliveries
     KEY (supplier_id,material_id)
     SOURCE KEY (supplier_id) REFERENCES suppliers (supplier_id)
     DESTINATION KEY (material_id) REFERENCES materials_inventory (material_id)
     LABEL Provides
     PROPERTIES (delivery_date, quantity),
   demo_dataset.product_materials_used
     KEY (production_process_id, material_id)
     SOURCE KEY (material_id) REFERENCES materials_inventory (material_id)
     DESTINATION KEY (production_process_id) REFERENCES final_products (production_process_id)
     LABEL IsIngredientInProduction
     PROPERTIES (quantity, production_process_id,material_id),
   demo_dataset.product_to_product_used
     KEY (production_process_id_target, production_process_id_source)
     SOURCE KEY (production_process_id_source) REFERENCES final_products (production_process_id)
     DESTINATION KEY (production_process_id_target) REFERENCES final_products (production_process_id)
     LABEL IsUsedInProduction
     PROPERTIES (quantity, production_process_id_source, production_process_id_target),
   demo_dataset.product_machines_used
     KEY (production_process_id, machine_id)
     SOURCE KEY (machine_id) REFERENCES machines (machine_id)
     DESTINATION KEY (production_process_id) REFERENCES final_products (production_process_id)
     LABEL IsMachineUsedInProduction
     PROPERTIES (production_process_id,machine_id,experimental_settings, maintanance_valid),
   demo_dataset.machine_configurations
     KEY (machine_id, parameter_id, from_date)
     SOURCE KEY (machine_id) REFERENCES machines (machine_id)
     DESTINATION KEY (parameter_id) REFERENCES configuration_parameters (parameter_id)
     LABEL UsesConfiguration
     PROPERTIES (from_date, to_date, parameter_value)
 )
;