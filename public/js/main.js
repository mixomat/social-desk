require(["jquery", "underscore-min", "backbone-min", "mustache" ], function($) {
	// called once all required dependencies have been loaded and document is ready
	require.ready(function() {
		require(["models/lists"], function(lists) {
			lists.init();
		});
	});
});