pipelineJob('static-site') {
    displayName('StaticSite Build')
    description('Creates docker image with release on Static-Site repository')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/static-site.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('Helm-CVE') {
    displayName('Helm CVE')
    description('Pipeline to build helm chart for helm')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/helm-webapp-cve-processor.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.release')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('Webapp-CVE') {
    displayName('Webapp CVE ')
    description('Pipeline to build Webapp')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/webapp-cve-processor.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('DB-CVE') {
    displayName('DB CVE  ')
    description('Pipeline to build DB Migration')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/db-migration.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('Aws-Infras') {
    displayName('Aws Infra')
    description('Pipeline to build Aws Infra')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/infra-aws.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('Consumer-app') {
    displayName('Consumer App')
    description('Pipeline to build Consumer App')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/webapp-cve-consumer.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('Consumer-Helm') {
    displayName('Consumer Helm')
    description('Pipeline to build Consumer Helm')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/helm-webapp-cve-consumer.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}
pipelineJob('Autoscaler-Helm') {
    displayName('Autoscaler Helm')
    description('Pipeline to build Autoscaler Helm')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/helm-eks-autoscaler.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}

pipelineJob('Operator-CVE') {
    displayName('Operator CVE ')
    description('Pipeline to build Operator')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/cve-operator.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.semantic')
            }
        }
    }
    triggers{
        githubPush()
    }
}

pipelineJob('HelmOperator-CVE') {
    displayName('HelmOperator CVE')
    description('Pipeline to build helm chart for HelmOperator')
    logRotator {
        daysToKeep(30)
        numToKeep(10)
    }
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team04/helm-cve-operator.git')
                        credentials('github_token')
                    }
                    branch('*/main')
                }
                scriptPath('Jenkinsfile.release')
            }
        }
    }
    triggers{
        githubPush()
    }
}