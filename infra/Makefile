PROJECT_ID=kunal-scratch
GCP_REGION=us-central1
GCP_ZONE=${GCP_REGION}-a
APP_NAME=dcentral-twitter
GKE_CLUSTER=dcentral-twitter-cluster
TF_STATE_BUCKET_NAME=${PROJECT_ID}-${APP_NAME}-infra

.PHONY: init
init:
	gcloud config set project ${PROJECT_ID}
	gcloud config set compute/zone ${GCP_ZONE}
	# Create a bucket if it doesn't exist
	gsutil ls -b gs://${TF_STATE_BUCKET_NAME} || gsutil mb -c standard -l ${GCP_REGION} gs://${TF_STATE_BUCKET_NAME}
	gsutil versioning set on gs://${TF_STATE_BUCKET_NAME}
	terraform init

.PHONY: design
design:
	terraform plan -var="project_id=${PROJECT_ID}" \
		-var="cluster_name=${GKE_CLUSTER}" \
		-var="region=${GCP_REGION}" \
		-var="zones=[\"${GCP_ZONE}\"]" \
		-out=${TF_STATE_BUCKET_NAME}.tfout

.PHONY: build
build:
	terraform apply ${TF_STATE_BUCKET_NAME}.tfout
	
.PHONY: tf-clean
tf-clean:
	rm -fr .terraform*

.PHONY: clean
clean:
