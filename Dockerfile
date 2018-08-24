FROM python:3.7.0-stretch

# Install any needed packages specified in requirements.txt
RUN apt-get update
RUN pip install -r requirements.txt

# Set the working directory to /
WORKDIR /
# Copy the directory contents into the container at /
COPY . /

# REQUIRED:
# ENV AZURE_STORAGE_ACCESS_KEY <access_key>
# ENV MLFLOW_SERVER_FILE_STORE
# ENV MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT

# OPTIONAL (if unset, will set to default):
ENV MLFLOW_SERVER_HOST 127.0.0.1
ENV MLFLOW_SERVER_PORT 5000
ENV MLFLOW_SERVER_WORKERS 4

CMD ["/setup_mlflow.sh"]