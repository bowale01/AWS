#!/bin/bash

# Get node information with labels
nodes=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.labels.karpenter\.sh/nodepool}{"\t"}{.metadata.labels.node\.kubernetes\.io/instance-type}{"\t"}{.metadata.labels.topology\.kubernetes\.io/zone}{"\t"}{.metadata.labels.karpenter\.sh/capacity-type}{"\n"}{end}')

# Iterate over each node and get the pods running on it
while IFS=$'\t' read -r node nodepool instance_type zone capacity_type; do
    pods=$(kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=$node -o custom-columns=":metadata.namespace,:metadata.name" | tr '\n' ',' | sed 's/,$//')
        echo "----------------------------------------"
            echo "Node: $node"
                echo "Nodepool: $nodepool"
                    echo "Instance Type: $instance_type"
                        echo "Zone: $zone"
                            echo "Capacity Type: $capacity_type"
                                echo "Pods:"
                                    echo "$pods" | tr ',' '\n' | sed 's/^/  - /'
                                        echo "----------------------------------------"
                                        done <<< "$nodes"
