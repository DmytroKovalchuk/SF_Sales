<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>setToInProgress</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>setToInProgress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>changeStatusToInProgress</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Visit__c.Status__c</field>
            <operation>equals</operation>
            <value>Planned</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>setToInProgress</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Visit__c.StartDateTime__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
