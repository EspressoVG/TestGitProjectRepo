/**
 * JS file for the Advanced Visualforce Webinar
 * 
 * Create our own top-level namespace for the JavaScript
 * functions used so we don't pollute the global namespace.
 * Depends on jQuery.
 */

var $R = jQuery.noConflict();

var VFWebinar = {

    /**
     * Shortcut to auto-populate fields in the View State example page.
     * It is absolutely NOT meant to be used for any other purpose. It is
     * hard-coded to deal with only one scenario, as well as the _current_
     * DOM structure of Salesforce detail pages (which may change in the
     * future). Do not re-use. Hence, the internals of this function are
     * not commented.
     */
    autoFillForm : function(containerId) {
        var cells = $R(".vfWebinarForm").find("td"),
            childNodes = null,
            childrenCount = 0,
            fieldLabel = "",
            valuesMap = {
                "FirstName" : "Gregory",
                "LastName" : "May",
                "Phone" : "(415) 555-1212",
                "Email" : "gregory.may@acmecorp.test",
                "AdditionalContactNames" : "Emily Wilska,Vaughn",
                "AccountName" : "Acme Corp",
                "Industry" : 24,
                "BillingCity" : "San Francisco",
                "OpportunityName" : "300 Units",
                "Amount" : "3500.00"
            };
        for (var i=0, j=cells.length; i<j; i++) {
            childNodes = cells[i].childNodes;
            childrenCount = childNodes !== null ? childNodes.length : 0;
            if (childrenCount > 0) {
                for (var k=0; k<childrenCount; k++) {
                    if (childNodes[k].tagName === "LABEL") {
                        fieldLabel = childNodes[k].innerHTML.replace(/\s+/g, '');
                        if (typeof valuesMap[fieldLabel] !== "undefined") {
                            if (fieldLabel === "Industry") {
                                cells[i+1].getElementsByTagName("SELECT")[0].selectedIndex = valuesMap[fieldLabel];
                            } else {
                                cells[i+1].getElementsByTagName("INPUT")[0].value = valuesMap[fieldLabel];
                            }
                            break;
                        }
                    }
                }
            }
        }
    },

    /**
     * Initialize the page. The only thing we're doing here is setting the HTML5
     * "placeholder" attribute of the text field. Visualforce components don't support
     * many HTML5 attributes currently, but they will soon. Stay tuned!!
     */
    init : function() {
        $R(".moreNames").attr("placeholder", "Barry, John Smith, ...");
    }

};
