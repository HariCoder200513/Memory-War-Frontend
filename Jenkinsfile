pipeline {
    agent any

    environment {
        FLUTTER_HOME = '/opt/flutter'
        ANDROID_HOME = '/opt/android-sdk'
        PATH         = "${FLUTTER_HOME}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${env.PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup') {
            steps {
                withCredentials([
                    file(credentialsId: 'mw-flutter-env', variable: 'FLUTTER_ENV')
                ]) {
                    sh '''
                        cp "$FLUTTER_ENV" .env
                        chmod 644 .env
                        flutter pub get
                    '''
                }
            }
        }

        stage('Analyze') {
            steps {
                sh 'flutter analyze --no-fatal-infos'
            }
        }

        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk',
                                 fingerprint: true
            }
        }

        stage('Publish to GitHub Release') {
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
                                build/app/outputs/flutter-apk/app-release.apk \
                                --repo HariCoder200513/Memory-War-Frontend \
                                --title "Memory Wars ${tag}" \
                                --notes "Build #${env.BUILD_NUMBER}" \
                                --latest
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Frontend pipeline succeeded.'
        }
        failure {
            echo 'Frontend pipeline failed.'
        }
        always {
            cleanWs()
        }
    }
}
