import psycopg2
import logging
import os

# Ensure the log directory exists
log_file = 'D://updaterepository.txt'
log_directory = os.path.dirname(log_file)

if not os.path.exists(log_directory):
    os.makedirs(log_directory)

# Set up logging
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    filemode='w',
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Prompt user for inputs
release_version = input("Please enter the release version: ")
party_id = input("Please enter the party ID: ")

# Source and target database connection parameters
source_db_params = {
    'dbname': 'RELEASE_REPORT',
    'user': 'gslpgadmin',
    'password': 'gmpl',
    'host': '10.14.4.33'
}

target_db_params = {
    'dbname': 'report_repository',
    'user': 'postgres',
    'password': 'report@ginesys',
    'host': '172.28.8.9'
}

# Initialize DB connections and cursors
source_connection = None
source_cursor = None
target_connection = None
target_cursor = None

try:
    # Connect to Source DB
    try:
        print("Connecting to Source DB...")
        source_connection = psycopg2.connect(**source_db_params)
        source_cursor = source_connection.cursor()
        print("✅ Source DB Connected")
        logging.info("✅ Connected to Source DB successfully.")
    except Exception as e:
        print(f"❌ Failed to connect to Source DB: {e}")
        logging.error(f"❌ Failed to connect to Source DB: {e}")
        raise

    # Connect to Target DB
    try:
        print("Connecting to Target DB...")
        target_connection = psycopg2.connect(**target_db_params)
        target_cursor = target_connection.cursor()
        print("✅ Target DB Connected")
        logging.info("✅ Connected to Target DB successfully.")
    except Exception as e:
        print(f"❌ Failed to connect to Target DB: {e}")
        logging.error(f"❌ Failed to connect to Target DB: {e}")
        raise

    # Step 1: Handle data for ex_content_release
    sql_query_release = """
    SELECT * FROM ginview.ex_content_dev WHERE release_version = %s;
    """
    source_cursor.execute(sql_query_release, (release_version,))
    release_results = source_cursor.fetchall()

    insert_command_release = """
    INSERT INTO ginview.Ex_content_release (
        content_id, content_type, report_type, content_attribute, name, description,
        text_content, bit_content, deleted_flag, created_date, created_by, modified_date,
        modified_by, owner_id, exports_allowed, inherit_flag, default_party_type_id,
        default_access_flags, extended_attributes, default_export_type,
        report_tree_shortcut_action, use_cache_execution, is_cache_valid,
        associated_reports, reportfoldercode, release_version, action
    ) VALUES (
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
    );
    """

    for row in release_results:
        try:
            target_cursor.execute(insert_command_release, row)
            logging.info(f"Inserted row in Ex_content_release: {row}")
        except psycopg2.Error as e:
            logging.error(f"Error inserting row in Ex_content_release: {row} - {e}")
            target_connection.rollback()

    # Step 2: Handle data for ex_content_access_release
    sql_query_access = """
    SELECT * 
    FROM ginview.ex_content_access_dev 
    WHERE release_version = %s
    AND (party_id = %s OR party_id IS NULL);
    """
    source_cursor.execute(sql_query_access, (release_version, party_id))
    access_results = source_cursor.fetchall()

    insert_command_access = """
    INSERT INTO ginview.ex_content_access_release (
        content_id, parent_id, party_type_id, party_id, sort_order, 
        access_flags, child_inherits, output_file_path, batch_output_filename, schedule_output_filename, release_version, action
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
    """

    for row in access_results:
        try:
            target_cursor.execute(insert_command_access, row)
            logging.info(f"Inserted row in Ex_content_access_release: {row}")
        except psycopg2.Error as e:
            logging.error(f"Error inserting row in Ex_content_access_release: {row} - {e}")
            target_connection.rollback()

    # Commit the transactions if all succeeds
    target_connection.commit()
    print("✅ Data migration completed successfully.")
    logging.info("✅ Data migration completed successfully.")

except psycopg2.Error as e:
    logging.error(f"Database Error: {e}")
    if target_connection:
        target_connection.rollback()

finally:
    # Close the connections
    if source_cursor:
        source_cursor.close()
    if source_connection:
        source_connection.close()
    if target_cursor:
        target_cursor.close()
    if target_connection:
        target_connection.close()
    logging.info("Database connections closed.")
    print("ℹ️ All database connections closed.")
