FROM python:3.8-slim

MAINTAINER Maurice Brinkmann <mauricebrinkmann@users.noreply.github.com>
LABEL Tiny Python 3.8 image incl. Graphviz and Python script for Jira issue dependency graph generation

ENV WORK_DIR /opt/mb/work
ENV TOOLS_DIR /opt/mb/tools
ENV JIRA_DEPENDENCY_GRAPH_GENERATOR create-jira-dependency-graph.py

RUN mkdir -p ${TOOLS_DIR}
COPY ${JIRA_DEPENDENCY_GRAPH_GENERATOR} ${TOOLS_DIR}/
RUN chmod ug+rx ${TOOLS_DIR}/*

RUN apt-get update \
  && apt-get install -y --no-install-recommends graphviz \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir pyparsing pydot requests
  
# A dedicated work folder to allow for the creation of temporary files
RUN mkdir -p ${WORK_DIR}
WORKDIR ${WORK_DIR}

ENV TOOL "${JIRA_DEPENDENCY_GRAPH_GENERATOR}"
ENV GRAPH_TYPE svg

CMD ${TOOLS_DIR}/${TOOL} --exclude-link "created" --exclude-link "created by" --exclude-link "clones" --exclude-link "is cloned by" --user="${JIRA_USER}" --password="${JIRA_PASSWORD}" --jira="${JIRA_URL}" ${JIRA_ISSUES} | tee graph.dot | dot -o graph.${GRAPH_TYPE} -T${GRAPH_TYPE}
