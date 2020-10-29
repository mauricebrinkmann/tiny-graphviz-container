FROM python:3.8-slim

ENV WORK_DIR /opt/mb/work
ENV TOOLS_DIR /opt/mb/tools

RUN mkdir -p ${TOOLS_DIR}
COPY create-jira-dependency-graph.py ${TOOLS_DIR}/

RUN apt-get update \
  && apt-get install -y --no-install-recommends graphviz \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir pyparsing pydot requests
  
# A dedicated work folder to allow for the creation of temporary files
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}
