# Source these values for a small cluster

# CLUSTER VALUES
# Change cluster name to a unique name that can include alphanumeric characters and hyphens only.
export NAME=small
export CLUSTER_LABELS="forgerock.io/cluster=cdm-small"

# cluster-up.sh retrieves the location from the user's az config.  Uncomment below to override:
# export LOCATION=eastus

# Name of Azure Container Registry.  AKS needs to be given access to ACR. Please amend to your registry name.
export ACR_NAME="forgeops" 

# PRIMARY NODE POOL VALUES
export VM_SIZE=Standard_F8s_v2 # vCPU*8, Mem GiB*16, Compute Intensive, Premium Storage(with caching)
export NODE_COUNT=3
export MIN=1
export MAX=4

# DS NODE POOL VALUES
export CREATE_DS_POOL=true
export DS_VM_SIZE=Standard_DS4_v2 # vCPU*8, Mem GiB*28, Premium Storage(with caching)
export DS_NODE_COUNT=3
