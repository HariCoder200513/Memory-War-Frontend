pipeline {

    agent any

    parameters {
        string(name: 'EC2_HOST', defaultValue: '', description: 'EC2 instance public IP or hostname to deploy to')
    }

    environment {
        APP_NAME       = 'memory-wars'
        FLUTTER_HOME   = '/opt/flutter'
        PATH           = "${FLUTTER_HOME}/bin:${env.PATH}"
        BACKEND_DIR    = 'memory_wars_backend'
        FRONTEND_DIR   = 'memory_wars_mobile'
        BINARY_NAME    = 'memory-wars-server'
        DEPLOY_DIR     = '/opt/memory-wars'
        EC2_USER       = 'ubuntu'
    }

    stages {

        // ─────────────────────────────────────
        //  CHECKOUT
        // ─────────────────────────────────────
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ─────────────────────────────────────
        //  FRONTEND — Flutter APK
        // ─────────────────────────────────────
        stage('Frontend: Setup') {
            steps {
                dir("${FRONTEND_DIR}") {
                    sh '''
                        flutter --version
                        flutter pub get
                    '''
                }
            }
        }

        stage('Frontend: Analyze') {
            steps {
                dir("${FRONTEND_DIR}") {
                    sh 'flutter analyze --no-fatal-infos'
                }
            }
        }


        stage('Frontend: Build APK') {
            steps {
                dir("${FRONTEND_DIR}") {
                    withCredentials([
                        string(credentialsId: 'mw-google-client-id', variable: 'MW_GOOGLE_CLIENT_ID')
                    ]) {
                        sh """
                            cat > .env << EOF
API_BASE_URL=http://${params.EC2_HOST}:8080/api/v1
API_BASE_URL_IOS=http://${params.EC2_HOST}:8080/api/v1
GOOGLE_CLIENT_ID=\${MW_GOOGLE_CLIENT_ID}
CONNECTION_TIMEOUT=30
RECEIVE_TIMEOUT=30
ENVIRONMENT=development
EOF
                            flutter build apk --release
                        """
                    }
                }
                archiveArtifacts artifacts: "${FRONTEND_DIR}/build/app/outputs/flutter-apk/app-release.apk",
                                 fingerprint: true
            }
        }

        // ─────────────────────────────────────
        //  BACKEND — Go binary
        // ─────────────────────────────────────
        stage('Backend: Setup') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh '''
                        go version
                        go mod download
                    '''
                }
            }
        }

        stage('Backend: Vet') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh 'go vet ./...'
                }
            }
        }

        stage('Backend: Test') {
            steps {
                dir("${BACKEND_DIR}") {
                    withCredentials([
                        string(credentialsId: 'mw-database-url', variable: 'DATABASE_URL'),
                        string(credentialsId: 'mw-jwt-secret', variable: 'JWT_SECRET')
                    ]) {
                        sh 'go test ./... -v -cover'
                    }
                }
            }
        }

        stage('Backend: Build') {
            steps {
                dir("${BACKEND_DIR}") {
                    sh '''
                        CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
                            go build -ldflags="-s -w" \
                            -o ${BINARY_NAME} ./cmd/server
                    '''
                }
                archiveArtifacts artifacts: "${BACKEND_DIR}/${BINARY_NAME}",
                                 fingerprint: true
            }
        }

        // ─────────────────────────────────────
        //  DEPLOY — Backend to EC2
        // ─────────────────────────────────────
        stage('Deploy Backend to EC2') {
            when {
                allOf {
                    branch 'main'
                    expression { params.EC2_HOST?.trim() }
                }
            }
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'mw-ec2-ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER'),
                    string(credentialsId: 'mw-database-url', variable: 'DATABASE_URL'),
                    string(credentialsId: 'mw-jwt-secret', variable: 'JWT_SECRET'),
                    string(credentialsId: 'mw-google-client-id', variable: 'GOOGLE_CLIENT_ID'),
                    string(credentialsId: 'mw-smtp-host', variable: 'SMTP_HOST'),
                    string(credentialsId: 'mw-smtp-port', variable: 'SMTP_PORT'),
                    string(credentialsId: 'mw-smtp-user', variable: 'SMTP_USER'),
                    string(credentialsId: 'mw-smtp-password', variable: 'SMTP_PASSWORD'),
                    string(credentialsId: 'mw-smtp-from', variable: 'SMTP_FROM'),
                    string(credentialsId: 'mw-frontend-base-url', variable: 'FRONTEND_BASE_URL')
                ]) {
                    sh '''
                        chmod 600 "$SSH_KEY"

                        # Copy binary to EC2
                        EC2_TARGET="${EC2_USER}@${EC2_HOST}"

                        scp -o StrictHostKeyChecking=no -i "$SSH_KEY" \
                            ${BACKEND_DIR}/${BINARY_NAME} \
                            ${EC2_TARGET}:${DEPLOY_DIR}/${BINARY_NAME}.new

                        # Deploy: write .env, swap binary, restart
                        ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" ${EC2_TARGET} << 'DEPLOY_SCRIPT'
                            set -e
                            cd /opt/memory-wars

                            cat > .env << ENVEOF
PORT=8080
DATABASE_URL=${DATABASE_URL}
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRY=15m
REFRESH_EXPIRY=168h
GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_USER=${SMTP_USER}
SMTP_PASSWORD=${SMTP_PASSWORD}
SMTP_FROM=${SMTP_FROM}
FRONTEND_BASE_URL=${FRONTEND_BASE_URL}
ENVIRONMENT=production
ENVEOF
                            chmod 600 .env

                            mv memory-wars-server.new memory-wars-server
                            chmod +x memory-wars-server

                            sudo systemctl restart memory-wars
DEPLOY_SCRIPT
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Memory Wars full pipeline succeeded."
        }
        failure {
            echo "Pipeline failed."
        }
        always {
            cleanWs()
        }
    }
}
