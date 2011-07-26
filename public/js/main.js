require(["jquery", "underscore-min", "backbone-min" ], function($) {
	
	var Tweet = Backbone.Model.extend({});
	
	var Timeline = Backbone.Collection.extend({
		model: Tweet,
		url: function () {
			'/lists/' + this.get['id'] + '/timeline'
		} 
	});
	
	var timeline = new Timeline();
	
	
	var TimelineView = Backbone.View.extend({
		
		events : {
			"click option": "timeline"
		},

		initialize : function() {
			_.bindAll(this, "render", "timeline");
		},	
		
		timeline: function() {
			alert("switching timeline");
		},
		
		render: function() {
			console.log("render called");
		}
		
		
	});
	
	window.app = new TimelineView();
	console.log(window.app);
});