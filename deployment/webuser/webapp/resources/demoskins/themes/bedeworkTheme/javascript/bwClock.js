/*
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
*/

var bwClockHour = null;
var bwClockMinute = null;
var bwClockRequestedType = null;
var bwClockCurrentType = null;

(function($){  
  $.fn.bwTimePicker = function(options) { 
    
    var defaults = {  
      hour24: false,
      attachToId: null,
      hourId: null,
      minuteId: null,
      ampmId: null
    };  
    var options = $.extend(defaults, options);
    
    var bwTimePickerContent = "";
    bwTimePickerContent += '<div class="bwTimePicker">';
    bwTimePickerContent += '<div class="bwTimePickerCloser">x</div>';
    bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerHours"><h6>Hour</h6><div class="bwTimePickerVals">';
    if (options.hour24) {
      bwTimePickerContent += '<ul><li>0</li><li>1</li><li>2</li><li>3</li><li>4</li><li>5</li></ul>';
      bwTimePickerContent += '<ul><li>6</li><li>7</li><li>8</li><li>9</li><li>10</li><li>11</li></ul>';
      bwTimePickerContent += '<ul><li>12</li><li>13</li><li>14</li><li>15</li><li>16</li><li>17</li></ul>';
      bwTimePickerContent += '<ul><li>18</li><li>19</li><li>20</li><li>21</li><li>22</li><li>23</li></ul>';
    } else {
      bwTimePickerContent += '<ul><li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li></ul>';
      bwTimePickerContent += '<ul><li>7</li><li>8</li><li>9</li><li>10</li><li>11</li><li>12</li></ul>';
    }
    bwTimePickerContent += '</div></div>';
    bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerColon">:</div>';
    bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerMinutes"><h6>Minute</h6><div class="bwTimePickerVals">';
    bwTimePickerContent += '<ul><li>00</li><li>10</li><li>20</li><li>30</li><li>40</li><li>50</li></ul>';
    bwTimePickerContent += '<ul><li>05</li><li>15</li><li>25</li><li>35</li><li>45</li><li>55</li></ul>';
    bwTimePickerContent += '</div></div>';
    if (!options.hour24) {
      bwTimePickerContent += '<div class="bwTimePickerColumn bwTimePickerAmPm"><ul><li>am</li><li>pm</li></ul></div>';
    }
    return this.each(function() {  
      obj = $(this); 
      
      obj.addClass('bwTimePickerLink');
      $("#" + options.attachToId).css("position","relative");
      
      obj.toggle(
        function(){
          $("#" + options.attachToId).append(bwTimePickerContent);
          $(".bwTimePicker .bwTimePickerCloser").click(function(){
            obj.click();
          });
          $("#" + options.attachToId + " .bwTimePicker .bwTimePickerHours li").click(function(){
            $("#" + options.attachToId + " .bwTimePicker .bwTimePickerHours li").removeClass('bwTimePickerSelected');
            $(this).addClass('bwTimePickerSelected');
            var hours = $(this).html();
            if (hours == '12' && !options.hour24) {
              hours = 0;
            }
            $("#" + options.hourId).val(hours);
          });
          $("#" + options.attachToId + " .bwTimePicker .bwTimePickerMinutes li").click(function(){
            $("#" + options.attachToId + " .bwTimePicker .bwTimePickerMinutes li").removeClass('bwTimePickerSelected');
            $(this).addClass('bwTimePickerSelected');
            $("#" + options.minuteId).val($(this).html());
          });
          $("#" + options.attachToId + " .bwTimePicker .bwTimePickerAmPm li").click(function(){
            $("#" + options.attachToId + " .bwTimePicker .bwTimePickerAmPm li").removeClass('bwTimePickerSelected');
            $(this).addClass('bwTimePickerSelected');
            $("#" + options.ampmId).val($(this).html());
          });
        },
        function(){
          $("#" + options.attachToId + " .bwTimePicker").remove();
        }
      );
    });  
  };  
})(jQuery); 

function bwClockLaunch(type,hour24) {
  var clockContent = "";
  clockContent += '<div id="bwNewClock">';
  clockContent += '<div class="clockColumn"><h6>Hour</h6><div class="clockVals">';
  clockContent += '<ul><li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li></ul>';
  clockContent += '<ul><li>7</li><li>8</li><li>9</li><li>10</li><li>11</li><li>12</li></ul>';
  clockContent += '</div>';
  if (hour24) {
    
  } 
  clockContent += '<div class="clockColumn"><h6>Minute</h6><div class="clockVals">';
  clockContent += '<ul><li>00</li><li>10</li><li>20</li><li>30</li><li>40</li><li>50</li></ul>';
  clockContent += '<ul><li>05</li><li>15</li><li>25</li><li>35</li><li>45</li><li>55</li></ul>';
  clockContent += '</div>';
  if (!hour24) {
    clockContent += '<div class="clockVals"><ul><li>AM</li><li>PM</li></ul></div>';
  }
  
  var $clockWidget = $('<div></div>')
    .html(clockContent)
    .dialog({
      autoOpen: false
    });
  $clockWidget.dialog('open');
}

function bwClockUpdateDateTimeForm(valType,val,hour24) {
  // valType: "hour" or "minute"
  // val: hour or minute value as integer
  // hour24: true (24hr clock) or false (12hr clock + am/pm) 
  if (bwClockRequestedType) {
    try {
      if (valType == 'minute') {
        var fieldName = bwClockRequestedType + ".minute"
        window.document.eventForm[fieldName].value = val;
        if (val < 10) {
          val = "0" + val; // pad the value for display
        }
        bwClockMinute = val;
      } else {
        var fieldName = bwClockRequestedType + ".hour"
        if (hour24) {
          window.document.eventForm[fieldName].value = val;
          if (val < 10) {
            val = "0" + val; // pad the value for display
          }
          bwClockHour = val;
        } else {
          var hour12 = val;
          if (hour12 > 12) {
            hour12 -= 12;
          } else if (hour12 == 12) {
            hour12 = 0; // noon and midnight are both represented by '0' in 12hr mode
          }
          window.document.eventForm[fieldName].value = hour12;
          if (val < 10) {
            val = "0" + val; // pad the value for display
          }
          bwClockHour = val;
          // now set the am/pm field
          fieldName = bwClockRequestedType + ".ampm";
          window.document.eventForm[fieldName].value = bwClockGetAmPm(bwClockHour);
        }
      }
      if (bwClockHour && bwClockMinute) {
        document.getElementById("bwClockTime").innerHTML = bwClockHour + ":" + bwClockMinute + " , " + bwClockConvertAmPm(bwClockHour) + ":" + bwClockMinute + " " + bwClockGetAmPm(bwClockHour);
      } else if (bwClockMinute) {
        document.getElementById("bwClockTime").innerHTML = ":" + bwClockMinute;
      } else {
        document.getElementById("bwClockTime").innerHTML = bwClockHour + " , " + bwClockConvertAmPm(bwClockHour) + " " + bwClockGetAmPm(bwClockHour);
      }
    } catch(e) {
      alert("There was an error:\n" + e );
    }
  } else {
    alert("The date type is null.");
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
    return 'am';
  } else {
    return 'pm';
  }
}
