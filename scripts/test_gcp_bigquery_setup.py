from google.cloud import bigquery
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def configure_gcp_credentials(credentials_path):
    """
    Configures the Google Cloud credentials for authentication.

    Args:
        credentials_path (str): The path to the Google Cloud credentials JSON file.
    """
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credentials_path
    logging.info(f"GCP credentials configured from {credentials_path}")

def initialize_bigquery_client():
    """
    Initializes the BigQuery client.

    Returns:
        bigquery.Client: The initialized BigQuery client.
    """
    return bigquery.Client()

def test_bigquery_client(credentials_path):
    """
    Tests the configuration of GCP credentials and the initialization of the BigQuery client.
    
    Args:
        credentials_path (str): The path to the Google Cloud credentials JSON file.
    """
    try:
        # Configure the credentials
        configure_gcp_credentials(credentials_path)

        # Initialize the BigQuery client
        client = initialize_bigquery_client()

        # Execute a simple operation to test the client
        datasets = list(client.list_datasets())
        if datasets:
            logging.info(f"Datasets found: {[dataset.dataset_id for dataset in datasets]}")
        else:
            logging.info("No datasets found in the project.")

        logging.info("Credentials configuration and client initialization successful!")
    except Exception as e:
        logging.error(f"Error initializing BigQuery client: {e}")

if __name__ == "__main__":
    # Provide the path to your credentials file here
    credentials_path = '.gcp_credentials/datario-project-3d19456dcded.json'
    test_bigquery_client(credentials_path)