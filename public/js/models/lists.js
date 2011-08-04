define(['jquery', 'text!templates/timeline.html'], function ($,timelineTemplate) {
	var me = {};
	me.views = {};
	
	var Timeline = Backbone.Model.extend({
		url: function () {
			return '/lists/' + this.get('id') + '/timeline';
		} 
	});


	var TimelineView = Backbone.View.extend({
		el: $("#container"),
		
		events: {
			"click li.list": "timeline"
		},

		initialize : function() {
			_.bindAll(this, "render", "timeline", "switchTimeline");
		},	
		
		timeline: function(event) {
			var id = $(event.target).data("list");
			var name =  $(event.target).html();
			this.switchTimeline(id,name);
		},

		switchTimeline: function(id, name) {
			this.model = new Timeline({"id": id, "name": name});
			this.model.bind('change', this.render);
			this.model.fetch();
		},
			
		render: function() {
			console.log("render called:", this.model);
			var html = Mustache.to_html(timelineTemplate, this.model.attributes);
			$("#timeline").html(html);
			
			return this;			
		}
	});
	
	me.init = function() {
		me.views.timeline = new TimelineView({
			el: $("#container")
		});
		return me;
	}
	
	return me;
});