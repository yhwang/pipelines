#!/bin/bash

set -ex

NS=$1
shift
EXECUTOR_TASK_TEMPLATE_NAME=$1
shift
EXECUOTR_SPEC=$1
shift

echo "${EXECUOTR_SPEC}"
IMAGE=$(echo "${EXECUOTR_SPEC}" | jq '.container.image')
COMMANDS=$(echo "${EXECUOTR_SPEC}" | jq '.container.command')

SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -k -H "Authorization: Bearer ${SA_TOKEN}" \
    "https://kubernetes.default.svc.cluster.local/apis/tekton.dev/v1beta1/namespaces/${NS}/tasks/${EXECUTOR_TASK_TEMPLATE_NAME}" | \
    jq ".spec.steps[0].command=${COMMANDS}|.spec.steps[0].image=${IMAGE}" | \
    curl -X PUT -k -H "Authorization: Bearer ${SA_TOKEN}" -H "Content-Type: application/json" \
    "https://kubernetes.default.svc.cluster.local/apis/tekton.dev/v1beta1/namespaces/${NS}/tasks/${EXECUTOR_TASK_TEMPLATE_NAME}" --data @- ;
