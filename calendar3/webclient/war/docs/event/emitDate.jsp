<%@ taglib uri='struts-bean' prefix='bean' %>
      <allday><bean:write name="date" property="dateType"/></allday><%--
        Value: true/false --%>
      <utcdate><bean:write name="date" property="utcDate"/></utcdate><%--
        Value: yyyymmdd - date value --%>
      <year><bean:write name="date" property="year"/></year><%--
        Value: yyyy - year value --%>
      <fourdigityear><bean:write name="date" property="fourDigitYear"/></fourdigityear><%--
        Value: yyyy - four digit year value.  --%>
      <month><bean:write name="date" property="month"/></month><%--
        Value: m - single or two digit month value --%>
      <twodigitmonth><bean:write name="date" property="twoDigitMonth"/></twodigitmonth><%--
        Value: mm - two digit month value --%>
      <monthname><bean:write name="date" property="monthName"/></monthname><%--
        Value (example): January - full month name --%>
      <day><bean:write name="date" property="day"/></day><%--
        Value: d - single or two digit day value --%>
      <dayname><bean:write name="date" property="dayName"/></dayname><%--
        Value (example): Monday - full day name --%>
      <twodigitday><bean:write name="date" property="twoDigitDay"/></twodigitday><%--
        Value: dd - two digit day value --%>
      <hour24><bean:write name="date" property="hour24"/></hour24><%--
        Value: h - single to two digit 24 hour value (0-23) --%>
      <twodigithour24><bean:write name="date" property="twoDigitHour24"/></twodigithour24><%--
        Value: hh - two digit 24 hour value (00-23) --%>
      <hour><bean:write name="date" property="hour"/></hour><%--
        Value: h - single to two digit hour value (0-12) --%>
      <twodigithour><bean:write name="date" property="twoDigitHour"/></twodigithour><%--
        Value: hh - two digit hour value (00-12) --%>
      <minute><bean:write name="date" property="minute"/></minute><%--
        Value: m - single to two digit minute value (0-59) --%>
      <twodigitminute><bean:write name="date" property="twoDigitMinute"/></twodigitminute><%--
        Value: mm - two digit minute value (00-59) --%>
      <ampm><bean:write name="date" property="amPm"/></ampm><%--
        Value: am,pm --%>
      <longdate><bean:write name="date" property="longDateString"/></longdate><%--
        Value (example): February 8, 2004 - long representation of the date --%>
      <shortdate><bean:write name="date" property="dateString"/></shortdate><%--
        Value (example): 2/8/04 - short representation of the date --%>
      <time><bean:write name="date" property="timeString"/></time><%--
        Value (example): 10:15 PM - representation of the time --%>
