<%@ taglib uri='struts-bean' prefix='bean' %>
<%@ taglib uri='struts-html' prefix='html' %>
<html:xhtml/>
<bean:define id="appBase" name="peForm" property="appBase" />

<html>
  <head>
  <title>BedeWork 24-Hour Clock</title>
  <style type="text/css">
    <!--
    body {
      padding: 0;
      margin: 0;
      font-family: Arial, Helvetica, sans-serif;
    }
    h1 {
      font-size: 0.9em;
      text-align: center;
      margin: 0 0 6px 0;
      padding: 2px 0;
      color: #eee;
      background-color: #000;
    }
    #clock {
      width: 380px;
      height: 380px;
      padding: 2px;
      margin: 0 auto;
      vertical-align: middle;
    }
    #dateTypeIndicator {
      position: absolute;
      bottom: 5px;
      left: 5px;
      font-weight: bold;
      font-style: italic;
      display: block;
      margin: 0;
      padding:0 ;
    }
    #time {
      position: absolute;
      bottom: 5px;
      display: block;
      width: 100%;
      text-align: center;
      font-size: 0.9em;
      font-weight: bold;
      margin: 0;
      padding:0 ;
    }
    #closeButton {
      position: absolute;
      bottom: 5px;
      right: 5px;
      display: block;
      margin: 0;
      padding:0 ;
    }
    #closeButton a {
      font-family: Verdana, Arial, Helvetica, sans-serif;
      font-size: 1.2em;
      border: 1px solid #333;
      margin: 0;
      padding:0 4px ;
      text-decoration: none;
      color: #333;
      background-color: white;
    }
    #closeButton a:hover {
      color: #eee;
      background-color: #333;
    }
    -->
  </style>
  <script language="JavaScript" type="text/javascript">

     var bwClockHour = null;
     var bwClockMinute = null;
     var bwClockParamList = new Array();
     bwClockParamList['dateType'] = null;
     bwClockParseQueryString();

     function bwClockParseQueryString() {
       var queryString = window.location.search.substring(1);
       var params = queryString.split('&');
       for (var i=0; i < params.length; i++) {
         var pos = params[i].indexOf('=');
         if (pos > 0) {
            var key = params[i].substring(0,pos);
            var val = params[i].substring(pos+1);
            paramList[key] = val;
            }
         }
      }

      function bwClockUpdateDateTimeForm(type,val) {
        if (window.opener && paramList['dateType']) {
          try {
            if (type == 'minute') {
              var fieldName = paramList['dateType'] + ".minute"
              window.opener.document.peForm[fieldName].value = val;
              bwClockMinute = val;
            } else {
              var fieldName = paramList['dateType'] + ".hour"
              window.opener.document.peForm[fieldName].value = val;
              bwClockHour = val;
            }
            if (hour && minute) {
              document.getElementById("time").innerHTML = bwClockHour + ":" + bwClockMinute + " , " + bwClockConvertAmPm(bwClockHour) + ":" + bwClockMinute + " " + bwClockGetAmPm(bwClockHour);
            } else if (minute) {
              document.getElementById("time").innerHTML = ":" + bwClockMinute;
            } else {
              document.getElementById("time").innerHTML = bwClockHour + " , " + bwClockConvertAmPm(bwClockHour) + " " + bwClockGetAmPm(bwClockHour);
            }
          } catch(e) {
            alert("The originating window no longer displays the event form:\n" + e );
          }
        } else {
          alert("The originating window is no longer open.");
        }
      }

      function bwClockConvertAmPm(hour24) {
        hour24 = parseInt(hour24,10);
        if (hour24 == 0) {
          return 12;
        } else if (hour24 > 12) {
          return hour24 - 12;
        } else {
          return hour24;
        }
      }

      function bwClockGetAmPm(hour24) {
        hour24 = parseInt(hour24,10);
        if (hour24 < 12) {
          return 'a.m.';
        } else {
          return 'p.m.';
        }
      }
    </script>
  </head>
  <body bgcolor="#FFFFFF">
    <h1 id="title">
      BedeWork 24-Hour Clock
    </h1>
    <div id="clock">
      <img id="clockMap" src="<%=appBase%>resources/clockMap.gif" width="368" height="368" border="0" alt="" usemap="#clockMap_Map" />
    </div>
    <div id="dateTypeIndicator">
      <script language="JavaScript" type="text/javascript">
        if(paramList['dateType'] == 'eventStartDate') {
          document.write('Start Time');
        } else if (paramList['dateType'] == 'eventEndDate') {
          document.write('End Time');
        } else {
          document.write('Inactive');
        }
      </script>
    </div>
    <div id="time">
      select time
    </div>
    <div id="closeButton">
      close <a href="javascript:window.self.close();">X</a>
    </div>
    <map name="clockMap_Map" id="clockMap_Map">
    <area shape="poly" alt="minute 00:55" coords="156,164, 169,155, 156,107, 123,128" href="javascript:bwClockUpdateDateTimeForm('minute','55')" />
    <area shape="poly" alt="minute 00:50" coords="150,175, 156,164, 123,128, 103,161" href="javascript:bwClockUpdateDateTimeForm('minute','50')" />
    <area shape="poly" alt="minute 00:45" coords="150,191, 150,175, 103,161, 103,206" href="javascript:bwClockUpdateDateTimeForm('minute','45')" />
    <area shape="poly" alt="minute 00:40" coords="158,208, 150,191, 105,206, 123,237" href="javascript:bwClockUpdateDateTimeForm('minute','40')" />
    <area shape="poly" alt="minute 00:35" coords="171,218, 158,208, 123,238, 158,261" href="javascript:bwClockUpdateDateTimeForm('minute','35')" />
    <area shape="poly" alt="minute 00:30" coords="193,218, 172,218, 158,263, 209,263" href="javascript:bwClockUpdateDateTimeForm('minute','30')" />
    <area shape="poly" alt="minute 00:25" coords="209,210, 193,218, 209,261, 241,240" href="javascript:bwClockUpdateDateTimeForm('minute','25')" />
    <area shape="poly" alt="minute 00:20" coords="216,196, 209,210, 241,240, 261,206" href="javascript:bwClockUpdateDateTimeForm('minute','20')" />
    <area shape="poly" alt="minute 00:15" coords="216,178, 216,196, 261,206, 261,159" href="javascript:bwClockUpdateDateTimeForm('minute','15')" />
    <area shape="poly" alt="minute 00:10" coords="209,164, 216,178, 261,159, 240,126" href="javascript:bwClockUpdateDateTimeForm('minute','10')" />
    <area shape="poly" alt="minute 00:05" coords="196,155, 209,164, 238,126, 206,107" href="javascript:bwClockUpdateDateTimeForm('minute','05')" />
    <area shape="poly" alt="minute 00:00" coords="169,155, 196,155, 206,105, 156,105" href="javascript:bwClockUpdateDateTimeForm('minute','00')" />
    <area shape="poly" alt="11 PM, 2300 hour" coords="150,102, 172,96, 158,1, 114,14" href="javascript:bwClockUpdateDateTimeForm('hour','23')" />
    <area shape="poly" alt="10 PM, 2200 hour" coords="131,114, 150,102, 114,14, 74,36" href="javascript:bwClockUpdateDateTimeForm('hour','22')" />
    <area shape="poly" alt="9 PM, 2100 hour" coords="111,132, 131,114, 74,36, 40,69" href="javascript:bwClockUpdateDateTimeForm('hour','21')" />
    <area shape="poly" alt="8 PM, 2000 hour" coords="101,149, 111,132, 40,69, 15,113" href="javascript:bwClockUpdateDateTimeForm('hour','20')" />
    <area shape="poly" alt="7 PM, 1900 hour" coords="95,170, 101,149, 15,113, 1,159" href="javascript:bwClockUpdateDateTimeForm('hour','19')" />
    <area shape="poly" alt="6 PM, 1800 hour" coords="95,196, 95,170, 0,159, 0,204" href="javascript:bwClockUpdateDateTimeForm('hour','18')" />
    <area shape="poly" alt="5 PM, 1700 hour" coords="103,225, 95,196, 1,205, 16,256" href="javascript:bwClockUpdateDateTimeForm('hour','17')" />
    <area shape="poly" alt="4 PM, 1600 hour" coords="116,245, 103,225, 16,256, 41,298" href="javascript:bwClockUpdateDateTimeForm('hour','16')" />
    <area shape="poly" alt="3 PM, 1500 hour" coords="134,259, 117,245, 41,298, 76,332" href="javascript:bwClockUpdateDateTimeForm('hour','15')" />
    <area shape="poly" alt="2 PM, 1400 hour" coords="150,268, 134,259, 76,333, 121,355" href="javascript:bwClockUpdateDateTimeForm('hour','14')" />
    <area shape="poly" alt="1 PM, 1300 hour" coords="169,273, 150,268, 120,356, 165,365" href="javascript:bwClockUpdateDateTimeForm('hour','13')" />
    <area shape="poly" alt="Noon, 1200 hour" coords="193,273, 169,273, 165,365, 210,364" href="javascript:bwClockUpdateDateTimeForm('hour','12')" />
    <area shape="poly" alt="11 AM, 1100 hour" coords="214,270, 193,273, 210,363, 252,352" href="javascript:bwClockUpdateDateTimeForm('hour','11')" />
    <area shape="poly" alt="10 AM, 1000 hour" coords="232,259, 214,270, 252,352, 291,330" href="javascript:bwClockUpdateDateTimeForm('hour','10')" />
    <area shape="poly" alt="9 AM, 0900 hour" coords="251,240, 232,258, 291,330, 323,301" href="javascript:bwClockUpdateDateTimeForm('hour','09')" />
    <area shape="poly" alt="8 AM, 0800 hour" coords="263,219, 251,239, 323,301, 349,261" href="javascript:bwClockUpdateDateTimeForm('hour','08')" />
    <area shape="poly" alt="7 AM, 0700 hour" coords="269,194, 263,219, 349,261, 363,212" href="javascript:bwClockUpdateDateTimeForm('hour','07')" />
    <area shape="poly" alt="6 AM, 0600 hour" coords="269,172, 269,193, 363,212, 363,155" href="javascript:bwClockUpdateDateTimeForm('hour','06')" />
    <area shape="poly" alt="5 AM, 0500 hour" coords="263,150, 269,172, 363,155, 351,109" href="javascript:bwClockUpdateDateTimeForm('hour','05')" />
    <area shape="poly" alt="4 AM, 0400 hour" coords="251,130, 263,150, 351,109, 325,68" href="javascript:bwClockUpdateDateTimeForm('hour','04')" />
    <area shape="poly" alt="3 AM, 0300 hour" coords="234,112, 251,130, 325,67, 295,37" href="javascript:bwClockUpdateDateTimeForm('hour','03')" />
    <area shape="poly" alt="2 AM, 0200 hour" coords="221,102, 234,112, 295,37, 247,11" href="javascript:bwClockUpdateDateTimeForm('hour','02')" />
    <area shape="poly" alt="1 AM, 0100 hour" coords="196,96, 221,102, 247,10, 209,-1, 201,61, 206,64, 205,74, 199,75" href="javascript:bwClockUpdateDateTimeForm('hour','01')" />
    <area shape="poly" alt="Midnight, 0000 hour" coords="172,96, 169,74, 161,73, 161,65, 168,63, 158,-1, 209,-1, 201,61, 200,62, 206,64, 205,74, 198,75, 196,96, 183,95" href="javascript:bwClockUpdateDateTimeForm('hour','00')" />
    </map>
  </body>
</html>