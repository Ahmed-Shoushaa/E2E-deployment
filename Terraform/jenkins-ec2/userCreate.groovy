userCreate.groovy
#!groovy
​
import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule
​
def instance = Jenkins.getInstance()
def env = System.getenv()
​
def user = env['JENKINS_USER']
def pass = env['JENKINS_PASSWORD']
​
if ( user == null || user.equals('') ) {
    println "Jenkins user variables not set (JENKINS_USER and JENKINS_PASSWORD)."
} else {
    println "Creating user " + user + "..."
​
    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount(user, pass)
    instance.setSecurityRealm(hudsonRealm)
​
    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)
    instance.save()
​
    Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
​
    println "User " + user + " was created"
}
Copy
