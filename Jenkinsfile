pipeline {
    agent any
    environment {
        GCR_PROJECT = 'sp-to-sp'
        GCR_REPO = "us-central1-docker.pkg.dev/sp-to-sp/testprod"
        IMAGE_TAG = "${env.BUILD_ID}"
        GCP_CREDENTIALS = 'shauryad224@gmail.com'
    }
    stages {
        stage('Checkout') {
            when {
                branch  "sit"
            }
            steps {
                git url: 'https://github.com/ShauryaDixit123/dep-kub', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${GCR_REPO}:${IMAGE_TAG} .'
                }
            }
        }
        stage('Login to GCR') {
            steps {
                script {
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
                    sh 'docker push ${GCR_REPO}:${IMAGE_TAG}'
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                script {
                    kubernetesDeploy(
                        configs: 'k8-deployment.yaml',
                        kubeconfigId: 'gke-cluster-config',
                        enableConfigSubstitution: true
                    )
                }
            }
        }
    }
}