import basedosdados as bd
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def test_basedosdados_connection(query, billing_project_id):
    """
    Tests the connection to Base dos Dados by running a SQL query.

    Args:
        query (str): The SQL query to execute.
        billing_project_id (str): The Google Cloud project ID for billing purposes.

    Returns:
        pandas.DataFrame: The results of the SQL query.
    """
    try:
        # Execute the SQL query using Base dos Dados and the provided billing project ID
        df = bd.read_sql(query, billing_project_id=billing_project_id)

        # Display the first few rows of the result
        logging.info("Successfully executed the query. Here are the first few rows of the result:")
        print(df.head())

        # Save the DataFrame to a CSV file in the './data/' directory
        output_path = './data/query_results.csv'
        df.to_csv(output_path, index=False)
        logging.info(f"Data saved to {output_path}")

        return df
    except Exception as e:
        logging.error(f"Error connecting to Base dos Dados: {e}")
        return None

if __name__ == "__main__":
    # Define the SQL query and the billing project ID
    query = 'SELECT * FROM `datario.dados_mestres.bairro` LIMIT 10'
    billing_project_id = 'datario-project'

    # Test the connection and query execution
    test_basedosdados_connection(query, billing_project_id)