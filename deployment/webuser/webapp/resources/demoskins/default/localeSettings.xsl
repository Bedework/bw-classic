<!-- 
    Licensed to Jasig under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Jasig licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License. You may obtain a
    copy of the License at:
    
    http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on
    an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied. See the License for the
    specific language governing permissions and limitations
    under the License.
-->
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- LOCALE SETTINGS -->
  <!-- A place for javascript strings and locale specific javascript overrides -->

  <xsl:template name="bedeworkSchedulingStrings">
    <script type="text/javascript">
      var bwAttendeeRoleChair = "CHAIR";
			var bwAttendeeRoleRequired = "REQ-PARTICIPANT";
			var bwAttendeeRoleOptional = "OPT-PARTICIPANT";
			var bwAttendeeRoleNonParticipant = "NON-PARTICIPANT";
			var bwAttendeeStatusNeedsAction = "NEEDS-ACTION";
			var bwAttendeeStatusAccepted = "ACCEPTED";
			var bwAttendeeStatusDeclined = "DECLINED";
			var bwAttendeeStatusTentative = "TENTATIVE";
			var bwAttendeeStatusDelegated = "DELEGATED";
			var bwAttendeeStatusCompleted = "COMPLETED";
			var bwAttendeeStatusInProcess = "IN-PROCESS";
			var bwAttendeeTypePerson = "person";
			var bwAttendeeTypeLocation = "location";
			var bwAttendeeTypeResource = "resource";
			
			// display strings for the values above
			// should be put with other internationalized strings
			// can be translated
			var bwAttendeeDispRoleChair = "chair";
			var bwAttendeeDispRoleRequired = "required participant";
			var bwAttendeeDispRoleOptional = "optional participant";
			var bwAttendeeDispRoleNonParticipant = "non-participant";
			var bwAttendeeDispStatusNeedsAction = "needs action";
			var bwAttendeeDispStatusAccepted = "accepted";
			var bwAttendeeDispStatusDeclined = "declined";
			var bwAttendeeDispStatusTentative = "tentative";
			var bwAttendeeDispStatusDelegated = "delegated";
			var bwAttendeeDispStatusCompleted = "completed";
			var bwAttendeeDispStatusInProcess = "in-process";
			var bwAttendeeDispTypePerson = "person";
			var bwAttendeeDispTypeLocation = "location";
			var bwAttendeeDispTypeResource = "resource";
			
			var bwFreeBusyDispTypeBusy = "BUSY";
			var bwFreeBusyDispTypeTentative = "TENTATIVE";
			var bwAddAttendeeDisp = "add attendee...";
			var bwAddDisp = "add";
			var bwAttendeeExistsDisp = "attendee exists";
			var bwAddAttendeeRoleDisp = "Role:";
			var bwAddAttendeeTypeDisp = "Type:";
			var bwAddAttendeeBookDisp = "Book:";
			var bwEventSubmitMeetingDisp = "send";
			var bwEventSubmitDisp = "save";
			
			var bwReqParticipantDisp = "required";
			var bwOptParticipantDisp = "optional";
			var bwChairDisp = "chair";
			var bwNonParticipant = "non-participant";
			var bwNeedsAction = "needs action";
			var bwAccepted = "accepted";
			var bwDeclined = "declined";
			var bwTentative = "tentative";
			var bwDelegated = "delegated";
			
			var bwErrorAttendees = "Error: attendees not returned";
      
    </script>
  </xsl:template>
</xsl:stylesheet>