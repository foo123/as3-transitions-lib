/**
 * FreelanceSwitch Jobs Loader
 * This project reads JS cache files loaded from the RSS feeds from jobs.freelanceswitch.com and displays them in a formatted HTML on the page.
 * 
 * @author Jordie Bodlay <jordie+code@jordie.org> EDIT Derek Herman
 * @package FreelanceSwitchRssReader
 * @subpackage JobsLoader
 */

var FreelanceSwitchJobs = {
	jobsCacheUrl: 'http://freelanceswitch.com/jobswidget/jobscache/', // Must have a trailing slash.
	loadedJobs: {}, // Leave this blank, it is loaded later on
	template: '<li class="fsjobs_job" id="{uniqid}"><a href="{applyurl}">{jobtitle} <span>{location}</span></a> </li>',
	templateTwo: '<h3><a href="{applyurl}" class="post_job_t">{jobtitle} <span>({location})</span></a></h3> <p>{description}</p>',
	loadJobs: function(category){
		if(typeof(FreelanceSwitchJobs.loadedJobs[category]) == 'undefined') {
			var scriptElement = document.createElement("script");
			scriptElement.type = "text/javascript";
			scriptElement.src= FreelanceSwitchJobs.jobsCacheUrl + "jobs." + category + ".js";
			document.getElementsByTagName("head")[0].appendChild(scriptElement);
		}else{
			FreelanceSwitchJobs.loadJobsFromJSON(FreelanceSwitchJobs.loadedJobs[category]);
		}
	},
	loadJobsFromJSON: function(json){
		var output = '';
		var thisJob = '';
		for(i=0; i<5; i++) {
		  var new_title = json[i].jobtitle;
      if ( new_title.length > 40 )
        new_title = new_title.substr(0,40).concat(' ...')
			thisJob = FreelanceSwitchJobs.template;
			thisJob = thisJob.replace(/\{date\}/g, json[i].date);
			thisJob = thisJob.replace(/\{jobtitle\}/g, new_title);
			thisJob = thisJob.replace(/\{location\}/g, json[i].location);
			thisJob = thisJob.replace(/\{description\}/g, json[i].description);
			thisJob = thisJob.replace(/\{applyurl\}/g, json[i].applyurl);
			thisJob = thisJob.replace(/\{uniqid\}/g, "fsjobs_id_" + Math.floor(Math.random()*10001));
			output += thisJob;
		}
		jQuery('#fsjobs_list').html(output);
		
		var output = '';
		var thisJob = '';
	  for(i=0; i<1; i++) {
      var r = Math.floor(Math.random()*3);
      var new_title = json[r].jobtitle;
      if ( new_title.length > 40 )
        new_title = new_title.substr(0,40).concat(' ...')
			thisJob = FreelanceSwitchJobs.templateTwo;
			thisJob = thisJob.replace(/\{jobtitle\}/g, new_title);
			thisJob = thisJob.replace(/\{location\}/g, json[r].location);
			thisJob = thisJob.replace(/\{description\}/g, json[r].description.replace(/(<([^>]+)>)/ig,"").substr(0,200).concat(' <a href="'+json[r].applyurl+'">...</a>'));
			thisJob = thisJob.replace(/\{applyurl\}/g, json[r].applyurl);
			output += thisJob;
			output += '<a href="http://jobs.freelanceswitch.com/" class="post_job_l">View more jobs</a>';
		}
		jQuery('#post_jobs_widget').html(output);
	}
};

jQuery(document).ready(function($){
  FreelanceSwitchJobs.loadJobs('all');
});