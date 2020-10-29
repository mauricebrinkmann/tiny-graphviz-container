FROM python:3.8-slim

RUN mkdir -p /opt/mb-tools
COPY create-jira-dependency-graph.py /opt/mb-tools/

RUN apt-get update \
  && apt-get install -y --no-install-recommends graphviz \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir pyparsing pydot requests
  
# A dedicated work folder to allow for the creation of temporary files
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
