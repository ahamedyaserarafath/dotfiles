Sample parameter groovy script

```
if (EXEC_TYPE.equals("AWS")){
 return [ "AWS-GROOVY" ]
}else if (EXECUTION_TYPE.equals("GCP")){
 return [ "GCP-GROOVY" ]
}else (EXECUTION_TYPE.equals("AZURE")){
 return [ "AZURE-GROOVY"]
}
```

Sample Pipeline

```
def notifySlack(String buildStatus = 'STARTED') {
    // Build status of null means success.
    buildStatus = buildStatus ?: 'SUCCESS'

    def color

    if (buildStatus == 'STARTED') {
        color = '#D4DADF'
    } else if (buildStatus == 'SUCCESS') {
        color = '#BDFFC3'
    } else if (buildStatus == 'UNSTABLE') {
        color = '#FFFE89'
    } else {
        color = '#FF9FA1'
    }

    def msg = "${buildStatus}: `${env.JOB_NAME}` #${env.BUILD_NUMBER}:\n${env.BUILD_URL}"

    slackSend(teamDomain: "sample" , token: "sampletoken" , channel: "#sample", color: color, message: msg)
}

node {

    try {
    
          stage("prerequsite-check"){
            node("nodename") {
                sh(script: '''
                    ls
                    pwd
                    echo stage1
                ''')
            }
          }
          stage("launch-ec2-instance"){
            node("nodename") {
                instance_public_dns=sh(script: '''
                        echo stage2''', returnStdout: true).trim()
            }
          }  
          stage("deploy"){
            node("nodename") {
                FILE=sh(script: """
                echo stage3${instance_public_dns} """, returnStdout: true).trim()
            }
          } 
    } catch (e) {
        currentBuild.result = 'FAILURE'
        throw e
    } finally {
        notifySlack(currentBuild.result)
    }  
}
```
