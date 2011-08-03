define(['jquery'], function ($) {
	var me = {};
	me.views = {};
	
	var Tweet = Backbone.Model.extend({});

	var Timeline = Backbone.Collection.extend({
		model: Tweet,
		url: function () {
			return '/lists/' + this.get['id'] + '/timeline';
		} 
	});


	var TimelineView = Backbone.View.extend({
		collection: new Timeline({id: "1"}),
		
		events: {
			"click .list": "render"
		},

		initialize : function() {
			_.bindAll(this, "render", "timeline");
			this.collection.bind('all', this.render);
			console.log("TimelineView intialized");
		},	
	
		timeline: function() {
			console.log("switching timeline");
		},
	
		render: function() {
			console.log("render called");
		}
	});
	
	me.init = function() {
		me.views.timeline = new TimelineView();
		return me;
	}
	
	return me;
});