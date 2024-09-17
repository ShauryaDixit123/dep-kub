pipeline {
    agent any
    
    environment {
        GCR_PROJECT = 'sp-to-sp'
        GCR_REPO = "us-central1-docker.pkg.dev/sp-to-sp/testprod"
        IMAGE_TAG = "${env.BUILD_ID}"
        GCP_CREDENTIALS =  shauryad224@gmail.com
    }
    
    triggers {
        // Poll for changes in the sit branch (use webho]oks for more efficiency)
        pollSCM('* * * * *') // This is just a placeholder, use webhook instead if possible
    }
    
    stages {
        stage('Checkout') {
            when {
                branch 'sit' // This ensures the stage only runs for the sit branch
            }
            steps {
                // Clone the sit branch
                git url: 'https://github.com/ShauryaDixit123/dep-kub', branch: 'sit'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image and tag it with the GCR repository and the build ID
                    sh 'docker build -t ${GCR_REPO}:${IMAGE_TAG} .'
                }
            }
        }
        
        stage('Login to GCR') {
            steps {
                script {
                    // Authenticate to Google Cloud and configure Docker for GCR
                    sh '''
                    gcloud auth activate-service-account --key-file=${GCP_CREDENTIALS}
                    gcloud auth configure-docker
                    '''
                }
            }
        }
        
        stage('Push to GCR') {
            steps {
                script {
                    // Push the Docker image to the Google Container Registry
                    sh 'docker push ${GCR_REPO}:${IMAGE_TAG}'
                }
            }
        }
        
        stage('Deploy to GKE') {
            steps {
                script {
                    // Deploy to Google Kubernetes Engine (GKE) using a Kubernetes YAML file
                    kubernetesDeploy(
                        configs: 'k8-deployment.yaml',    // Path to your Kubernetes deployment file
                        kubeconfigId: 'gke-cluster-config', // Jenkins credentials ID for kubeconfig
                        enableConfigSubstitution: true      // Enable config substitution for env variables
                    )
                }
            }
        }
    }
}
