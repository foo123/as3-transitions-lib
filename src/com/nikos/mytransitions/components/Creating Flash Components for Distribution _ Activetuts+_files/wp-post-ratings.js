// source lifted from here
// https://github.com/carhartl/jquery-cookie
jQuery.cookie = function (key, value, options) {

    // key and value given, set cookie...
    if (arguments.length > 1 && (value === null || typeof value !== "object")) {
        options = jQuery.extend({}, options);

        if (value === null) {
            options.expires = -1;
        }

        if (typeof options.expires === 'number') {
            var days = options.expires, t = options.expires = new Date();
            t.setDate(t.getDate() + days);
        }

        return (document.cookie = [
            encodeURIComponent(key), '=',
            options.raw ? String(value) : encodeURIComponent(String(value)),
            options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
            options.path ? '; path=' + options.path : '',
            options.domain ? '; domain=' + options.domain : '',
            options.secure ? '; secure' : ''
        ].join(''));
    }

    // key and possibly options given, get cookie...
    options = value || {};
    var result, decode = options.raw ? function (s) { return s; } : decodeURIComponent;
    return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
};

// this is our actual object that does things
var WpPostRatings = function(args) {
  return {
    init: function() {
      this.rpc = args.rpc
      this.post_id = args.post_id
      this.context = args.context
      this.base_url = args.base_url
      this.allow_voting = args.allow_voting
      this.widget = this.template()
      
      if (this.able_to_vote()) {
        this.make_widget_votable()
      }

      this.fetch_and_assign_existing_rating()
      this.place_widget_on_page()
    },

    able_to_vote: function() {
      return !this.already_voted() && this.allow_voting;
    },

    already_voted: function() {
      return $.cookie(this.cookie_key())
    },

    flag_as_voted: function() {
      $.cookie(this.cookie_key(), 'true', {expires: 365})
    },

    cookie_key: function() {
      return 'voted-on-post-' + this.post_id
    },

    make_widget_votable: function() {
      this.add_votable_hover_state()
      this.add_votable_click_event()
    },

    each_link: function(fn) {
      $('li a', this.widget).each(function(n, el) {
        fn(n, el)
      })
    },

    add_votable_hover_state: function() {
      var that = this

      this.each_link(function(n, el) {
        $(el).mouseover(function() {
          that.reset()
          var stop = false // can't break from each?
          that.each_link(function(n, a) {
            if (!stop) {
              $(a).addClass('hover')
            }
            if (el == a) {
              stop = true
            }
          })
        })

        $(el).mouseout(function() {
          that.reset()
          that.set_rating(that.rating)
        })
      })
    },

    remove_votable_events: function() {
      this.each_link(function(n, link) {
        $(link).unbind('mouseover')
        $(link).unbind('mouseout')
        $(link).unbind('click')
      })
    },

    reset: function() {
      this.each_link(function(n, el) {
        $(el).removeClass('hover').removeClass('active').removeClass('half')
      })
    },

    add_votable_click_event: function() {
      var that = this
      this.each_link(function(n, el) {
        $(el).click(function() {
          that.register_vote($(this).html(), function() {
            that.reset()
            that.get_rating({skip_cache: true, callback:function(n) {
              that.set_rating(n)
            }})
          })
        })
      })
    },

    register_vote: function(n, callback) {
      this.flag_as_voted()
      this.remove_votable_events()
      $.ajax({
        url: this.rpc,
        cached: false,
        type: 'POST',
        data: {action: 'wp_post_ratings_set_rating', rating: n, post_id: this.post_id},
        success: function(data, status, xhr) {
          callback()
        }
      })
    },

    fetch_and_assign_existing_rating: function() {
      var that = this
      this.get_rating({callback: function(rating) {
        that.rating = rating
        that.set_rating(rating)
      }})
    },

    get_rating: function(args) {
      this.fetch_cached_rating(args)
    },

    fetch_cached_rating: function(args) {
      var that = this
      $.ajax({
        url: this.base_url + '/wp-content/cache/ratings/post-' + this.post_id + '.xml',
        cache: !args.skip_cache,
        error: function(xhr, status, error) {
          that.fetch_rating_via_rpc(args)
        },
        success: function(xml, status, xhr) {
          var rating = parseFloat( $(xml).find('post rating').attr('average') )
          args.callback(rating)
        }
      })
    },

    fetch_rating_via_rpc: function(args) {
      $.ajax({
        url: this.rpc,
        cache: !args.skip_cache,
        data: {action: 'wp_post_ratings_get_rating', post_id: this.post_id},
        success: function(xml, status, xhr) {
          var rating = parseFloat( $(xml).find('post rating').attr('average') )
          args.callback(rating)
        }
      })
    },

    set_rating: function(n) {
      var half = n % 1 == 0.5
      var n = Math.floor(n)
      this.each_link(function(i, el) {
        if (i < n) {
          $(el).addClass('active')
        } else if (i == n && half) {
          $(el).addClass('active').addClass('half')
        }
      })
    },

    place_widget_on_page: function() {
      $('.post_taxonomy ul', this.context).after(this.widget)
    },

    template: function() {
      return $('<div id="tuts-rating" class="">' + 
          '<p><span> \\</span>Rating:</p>' + 
          '<ul id="">' + 
          '  <li><a href="javascript:void(0)" class="rate-this one">1</a></li>' + 
          '  <li><a href="javascript:void(0)" class="rate-this two">2</a></li>' + 
          '  <li><a href="javascript:void(0)" class="rate-this three">3</a></li>' + 
          '  <li><a href="javascript:void(0)" class="rate-this four">4</a></li>' + 
          '  <li><a href="javascript:void(0)" class="rate-this five">5</a></li>' + 
          '</ul>' + 
        '</div>');
    }
  }
}
