(function() {
  this.App || (this.App = {});

  App.facebook = {
    buildPagesGrid: function(pages) {
      $('#facebook-pages-cards .response-grid').empty();
      for(x in pages.data) {
        var page_name = pages.data[x].name.length > 12 ? pages.data[x].name.substring(0, 9) + '...' : pages.data[x].name;
        $('#facebook-pages-cards .response-grid').append(
          '<div class="col-lg-3 col-sm-4 col-xs-6 mt-2">' +
            '<div class="card">' +
              '<div class="view overlay hm-white-slight">' +
                '<img src="'+ pages.data[x].picture.data.url +'" class="img-fluid" alt="'+ pages.data[x].name +'">' +
              '</div>' +
              '<div class="card-block p-1">' +
                '<p class="text-xs-center groala-break-word">'+ page_name +'</p>' +
                '<div class="text-xs-center">' +
                  '<a class="btn-floating facebook-page-button" data-toggle="tab" href="#post-post" role="tab" data-facebook-page-id="'+ pages.data[x].id +'">' +
                    '<i class="fa fa-check left" aria-hidden="true"></i>' +
                  '</a>' +
                '</div>' +
              '</div>' +
            '</div>' +
          '</div>'
        );
      }
      $('#facebook-pages-cards .response-grid').removeClass('loading-response');
    },
    buildPostsGrid: function(posts) {
      $('#facebook-posts-cards .response-grid').empty();
      for(x in posts.data) {
        if(typeof(posts.data[x].message) === 'undefined' && typeof(posts.data[x].full_picture) === 'undefined') { continue }
        if (typeof(posts.data[x].message) !== 'undefined' && posts.data[x].message.length) {
          var post_text = posts.data[x].message.length > 97 ? posts.data[x].message.substring(0, 97) + '...' : posts.data[x].message;
        } else {
          var post_text = '';
        }
        if (typeof(posts.data[x].full_picture) !== 'undefined') {
          var post_img = '<img src="'+ posts.data[x].full_picture +'" class="img-fluid" alt="'+ posts.data[x].from.name +' Facebook Post">';
        } else {
          var post_img = '';
        }
        $('#facebook-posts-cards .response-grid').append(
          '<div class="col-lg-3 col-sm-4 col-xs-6 mt-2">' +
            '<div class="card">' +
              '<div class="view overlay hm-white-slight">' +
                post_img +
              '</div>' +
              '<div class="card-block">' +
                '<p class="groala-break-word">'+ post_text +'</p>' +
                '<div class="text-xs-center">' +
                  '<a class="btn-floating facebook-post-button" data-toggle="tab" href="#post-form" role="tab" data-facebook-post-id="'+ posts.data[x].id +'">' +
                    '<i class="fa fa-check left" aria-hidden="true"></i>' +
                  '</a>' +
                '</div>' +
              '</div>' +
            '</div>' +
          '</div>'
          // '<div class="media">' +
          //   '<a class="media-left waves-light">' +
          //     '<img class="rounded-circle" src="'+ posts.data[x].full_picture +'" alt="'+ posts.data[x].from.name +' Facebook Post">' +
          //   '</a>' +
          //   '<div class="media-body">' +
          //     '<p>'+ posts.data[x].message +'</p>' +
          //     '<div class="text-xs-center">' +
          //       '<button type="button" class="btn btn-secondary facebook-page-button" data-facebook-post-id="'+ posts.data[x].id +'">' +
          //         '<i class="fa fa-check-circle-o left" aria-hidden="true"></i>' +
          //         'Select' +
          //       '</button>' +
          //   '</div>' +
          // '</div>'
        );
      }
      $('#facebook-posts-cards .response-grid').removeClass('loading-response');
    },
    init: function(id) {
      FB.init({
        appId: id,
        status: false,
        cookie: true,
        xfbml: true
      });
    },
    loadSDK: function() {
      (function(d){
        var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
        if (d.getElementById(id)) {return;}
        js = d.createElement('script'); js.id = id; js.async = true;
        js.src = "//connect.facebook.net/en_US/all.js";
        ref.parentNode.insertBefore(js, ref);
      }(document));
    },
    login: function(args) {
      FB.login(function(response) {
        if (response.authResponse) {
          App.facebook.setToken(response);
        } else {
          alert('Authentication cancelled. Please try again.');
        }
      });
    },
    fetchPages: function(query) {
      $('#facebook-pages-cards .response-grid').addClass('loading-response');
      FB.api(
        '/search',
        {
          fields: 'category,id,name,picture.type(large)',
          type: 'page',
          q: query
        },
        function(response) {
          App.facebook.buildPagesGrid(response);
        }
      );
    },
    fetchPosts: function(page_id) {
      $('#facebook-posts-cards .response-grid').addClass('loading-response');
      FB.api(
        '/'+page_id+'/posts',
        {
          fields: 'id,from,full_picture,message'
        },
        function(response) {
          console.log('HEYO');
          App.facebook.buildPostsGrid(response);
        }
      );
    },
    setFacebookPage: function() {
      $('#facebook-pages-cards').on('click', '.facebook-page-button', function(){
        var page_id = $(this).data('facebook-page-id');
        $('#post_network_parent_id').val(page_id);
        App.facebook.fetchPosts(page_id);
      });
    },
    setFacebookPost: function() {
      $('#facebook-posts-cards').on('click', '.facebook-post-button', function(){
        var post_id = $(this).data('facebook-post-id');
        $('#post_network_post_id').val(post_id);
      });
    },
    setToken: function(response) {
      $.ajax({
        url: '/facebook_tokens/create_or_update',
        type: 'POST',
        data: {
          facebook_token: {
            network_user_id: response.authResponse.userID,
            token: response.authResponse.accessToken
          }
        },
        dataType: 'json',
        success: function(data){
          $('#new_post button, #post-sync-trigger').removeAttr('disabled');
        }
      });
    },
    status: function() {
      FB.getLoginStatus(function(response) {
        if (response.status === 'connected') {
          App.facebook.setToken(response);
        } else if (response.status === 'not_authorized') {
          // the user is logged in to Facebook,
          // but has not authenticated your app
          App.facebook.userLoggedOut(response.status);
        } else {
          // the user isn't logged in to Facebook.
          App.facebook.userLoggedOut();
        }
      });
      $('body').on('click', '.facebook-login', function(){
        App.facebook.login();
      });
    },
    userLoggedOut: function(status) {
      if (status === 'not_authorized') {
        $('#connected-facebook span').html('Status: Not Connected <button type="button" class="btn light-blue btn-sm waves-effect waves-light facebook-login">Connect</button>');
      } else {
        $('#connected-facebook span').html('Status: Logged Out <button type="button" class="btn light-blue btn-sm waves-effect waves-light facebook-login">Log In</button>');
      }
      $('#new_post button[type="submit"]').replaceWith('<button type="button" class="btn default-color facebook-login waves-effect waves-light"><i class="fa fa-check-circle-o left" aria-hidden="true"></i> Submit</button>');
      $('#post-sync-trigger').replaceWith('<button type="button" class="btn default-color facebook-login waves-effect waves-light"><i class="fa fa-refresh left" aria-hidden="true"></i> Sync Now</button>');
    }
  };

}).call(this);
