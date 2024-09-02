# Desafio Técnico - Cientista de Dados Júnior

- Este projeto é uma aplicação de análise de dados usando a biblioteca `basedosdados` e o Google BigQuery.

## Requisitos

- Python 3.7 ou superior
- Google Cloud SDK instalado
- Conta no Google Cloud com projeto configurado para usar o BigQuery
- Biblioteca `basedosdados` instalada

## Instalação

1. Clone o repositório:
    ```bash
    git clone https://github.com/AngelOttoni/emd-desafio-jr-ds-amo
    cd emd-desafio-jr-ds-amo
    ```

2. Crie e ative um ambiente virtual (recomendado):
    ```bash
    python3 -m venv .my_env
    source .my_env/bin/activate  # No Windows, use .my_env\Scripts\activate
    ```

3. Instale as dependências:
    ```bash
    pip install -r requirements.txt
    ```

## Configuração

1. **Credenciais do Google Cloud**: Configure as credenciais do Google Cloud.

    - Crie um projeto no Google Cloud e habilite o BigQuery.
    - Crie uma conta de serviço e faça o download do arquivo de chave JSON.
    - Coloque o arquivo JSON de credenciais na pasta `.gcp_credentials/` do projeto.

2. **Variáveis de Ambiente**: Configure a variável de ambiente `GOOGLE_APPLICATION_CREDENTIALS` para apontar para o caminho do arquivo de credenciais JSON. Adicione o seguinte comando no terminal ou adicione ao seu script de configuração:

    ```bash
    export GOOGLE_APPLICATION_CREDENTIALS=".gcp_credentials/datario-project-3d19456dcded.json"
    ```

## Executando o Projeto

1. Teste a configuração das credenciais do Google Cloud:
    ```bash
    python3 scripts/configure_gcp_credentials.py
    ```

2. Teste a conexão com a `basedosdados`:
    ```bash
    python3 scripts/test_basedosdados_connection.py
    ```

3. Execute o notebook em um ambiente Jupyter para ver os resultados para as perguntas listadas em `instructions/perguntas_sql.md`.

## Notas

- Certifique-se de ter permissões adequadas no projeto Google Cloud.
- Modifique o ID do projeto de faturamento (`billing_project_id`) conforme necessário.