pipeline {
    agent any

    parameters {
        string(name: 'EC2_HOST', defaultValue: '', description: 'EC2 public IP or hostname to deploy to')
    }

    environment {
        FLUTTER_HOME = '/opt/flutter'
        ANDROID_HOME = '/opt/android-sdk'
        PATH         = "${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${env.PATH}"
        FRONTEND_DIR = 'memory_wars_mobile'
        BACKEND_DIR  = 'memory_wars_backend'
        BINARY_NAME  = 'memory-wars-server'
        DEPLOY_DIR   = '/opt/memory-wars'
        EC2_USER     = 'ubuntu'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // ───────────── FRONTEND ─────────────

        stage('Frontend: Setup') {
            steps {
                withCredentials([
                    file(credentialsId: 'mw-flutter-env', variable: 'FLUTTER_ENV')
                ]) {
                    dir("${FRONTEND_DIR}") {
                        sh '''
                            cp "$FLUTTER_ENV" .env
                            ls -la .env
                            flutter pub get
                        '''
                    }
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
                    sh 'flutter build apk --release'
                }
                archiveArtifacts artifacts: "${FRONTEND_DIR}/build/app/outputs/flutter-apk/app-release.apk",
                                 fingerprint: true
            }
        }

        // ───────────── BACKEND ─────────────

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

        // ───────────── PUBLISH APK ─────────────

        stage('Publish APK to GitHub Release') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([
                    string(credentialsId: 'mw-github-token', variable: 'GH_TOKEN')
                ]) {
                    script {
                        def tag = "v1.0.0-build.${env.BUILD_NUMBER}"
                        sh """
                            gh release create ${tag} \
                                ${FRONTEND_DIR}/build/app/outputs/flutter-apk/app-release.apk \
                                --repo HariCoder200513/Memory-War-Frontend \
                                --title "Memory Wars ${tag}" \
                                --notes "Build #${env.BUILD_NUMBER}" \
                                --latest
                        """
                    }
                }
            }
        }

        // ───────────── DEPLOY BACKEND ─────────────

        stage('Deploy Backend to EC2') {
            when {
                allOf {
                    branch 'main'
                    expression { params.EC2_HOST?.trim() }
                }
            }
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'mw-ec2-ssh-key', keyFileVariable: 'SSH_KEY'),
                    file(credentialsId: 'mw-backend-env', variable: 'BACKEND_ENV')
                ]) {
                    sh '''
                        chmod 600 "$SSH_KEY"
                        EC2="${EC2_USER}@${EC2_HOST}"

                        scp -o StrictHostKeyChecking=no -i "$SSH_KEY" \
                            ${BACKEND_DIR}/${BINARY_NAME} "${EC2}:${DEPLOY_DIR}/${BINARY_NAME}.new"

                        scp -o StrictHostKeyChecking=no -i "$SSH_KEY" \
                            "$BACKEND_ENV" "${EC2}:${DEPLOY_DIR}/.env.new"

                        ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "${EC2}" '
                            cd /opt/memory-wars
                            mv .env.new .env && chmod 600 .env
                            mv memory-wars-server.new memory-wars-server && chmod +x memory-wars-server
                            sudo systemctl restart memory-wars
                        '
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded.'
        }
        failure {
            echo 'Pipeline failed.'
        }
        always {
            cleanWs()
        }
    }
}
