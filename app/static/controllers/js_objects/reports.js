function Report($http){

	var pg_requests = new Requests(null, null, $http);
	var interval_check_tree = {};

	function modalAlert(text, callback){

    	$('#modalAlert #buttonSub').off("click");
    	$('#modalAlert .modal-body').empty();
    	$('#modalAlert .modal-body').append("<p>"+text+"</p>");

    	$('#modalAlert #buttonSub').on("click", function(){
    		$("#buttonCancelAlert").click();
    		setTimeout(function(){callback()}, 400);
    	})

    	$('#modalAlert').modal("show");

    }

	var returned_functions = {
		 get_user_reports: function(callback){
		 	pg_requests.get_user_reports(function(response){
				callback(response);
			});
		 },
		 get_project_reports: function(project_id, pipelines_to_check, callback){
		 	pg_requests.get_project_reports(project_id, pipelines_to_check, function(response){
				callback(response);
			});
		 },
		 get_reports_by_strain: function(strain_id_to_search, callback){
		 	pg_requests.get_reports_by_strain(strain_id_to_search, function(response){
				callback(response);
			});
		 },
		 get_multiple_user_reports: function(ids, callback){

		 	if(ids == null){
		 		var table = $('#reports_table').DataTable();
    
			    var selected_job_ids = $.map(table.rows('.selected').data(), function(data){
			       return data.job_id;
			    });
		 	}
		 	else {
		 		selected_job_ids = ids;
		 	}

		 	if(selected_job_ids.length == 0) return callback(null);

		 	pg_requests.get_multiple_user_reports(selected_job_ids, function(response){
				callback(response);
			});
		 },
		 save_reports: function(current_job_ids, current_strain_names, callback){
		 	pg_requests.save_reports(current_job_ids, current_strain_names, CURRENT_SPECIES_ID, function(response){
		 		callback(response);
		 	});
		 },
		 get_saved_user_reports: function(callback){
		 	pg_requests.get_saved_user_reports(CURRENT_SPECIES_ID, function(response){
		 		callback(response);
		 	});
		 },
		 get_user_trees: function(callback){
		 	pg_requests.get_user_trees(CURRENT_SPECIES_ID, function(response){
		 		callback(response);
		 	});
		 },
		 get_strain_by_name: function(current_names, callback){
		 	count = 0;
		 	responses = [];

		 	var table = $('#reports_table').DataTable();

		 	if(current_names == null){
    	
    			var current_names = [];
			    $.map(table.rows('.selected').data(), function(data){
			    	if($.inArray(data.sample_name, current_names) === -1) current_names.push(data.sample_name);
			       //return data.sample_name;
			    });

		 	}
		 	
		 	for(x in current_names){
		 		pg_requests.get_strain_by_name(current_names[x], function(response){
		 			if(!response.data.hasOwnProperty("strain_metadata")) callback([]);
		 			count+=1;
		 			var to_send = JSON.parse(response.data.strain_metadata);
		 			//console.log(response);
		 			to_send.Sample = response.data.strainID;
		 			responses.push(to_send);
		 			if(count == current_names.length) callback(responses);

		 		});
		 	}
		 },
		 delete_combined_report: function(callback){

		  	var table = $('#saved_reports_table').DataTable();

		  	var selected_job_name = $.map(table.rows('.selected').data(), function(data){
		  			//console.log(data);
			       return data.name;
			    });

		  	var count = 0;

		  	for(i in selected_job_name){
		  		count++;
		  		pg_requests.delete_combined_report(selected_job_name[i], function(response){
		  			if (count == selected_job_name.length) callback(response);
			 	});
		  	}

		 },
		 sendToPHYLOViZ: function(job_ids, global_additional_data, species_id, callback){
		 	pg_requests.send_to_phyloviz(job_ids, global_additional_data, species_id, function(response){
		 		console.log(response);
		 		interval_check_tree[response.data] = setInterval(function(){ fetch_tree_job(response.data); }, 5000)


		 		function fetch_tree_job(redis_job_id){
		 			pg_requests.fetch_job(redis_job_id, function(response, job_id){
		 				console.log(response);
		 				if(response.data.status == true){
		 					clearInterval(interval_check_tree[job_id])
		 					modalAlert("Your tree is ready to be visualized! Go to the Trees tab at the Reports menu.", function(){
		 						
							});
		 				}
		 				else if(response.data.status == false){
		 					console.log(response.data.result);
		 					clearInterval(interval_check_tree[job_id])
		 					modalAlert("There was an error when producing the tree at PHYLOViZ Online.", function(){

				});
		 				}
		 			})
		 		}

		 		callback(response);
		 	});
		 }
		 /*sendToPHYLOViZ: function(total_data, callback){
		 	pg_requests.send_to_phyloviz(total_data[0], total_data[1], function(response){
		 		callback(response);
		 	});
		 }*/
		 
	}
	
	return returned_functions;
}