// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require, exports, module) {
    var $, Favorite, LoginForm, Profile, Recent, Spine, TEMPLATE, User, delay;
    Spine = require('Spine');
    $ = require('jQuery');
    delay = require('zooniverse/util').delay;
    User = require('zooniverse/models/User');
    Favorite = require('zooniverse/models/Favorite');
    Recent = require('zooniverse/models/Recent');
    LoginForm = require('zooniverse/controllers/LoginForm');
    TEMPLATE = require('zooniverse/views/Profile');
    Profile = (function(_super) {

      __extends(Profile, _super);

      Profile.prototype.className = 'zooniverse-profile';

      Profile.prototype.template = TEMPLATE;

      Profile.prototype.events = {
        'click .sign-out': 'signOut',
        'click .favorites .delete': 'onFavoriteDeleteClick',
        'click .recents button[name="more"]': 'loadMoreRecents',
        'click .favorites button[name="more"]': 'loadMoreFavorites'
      };

      Profile.prototype.elements = {
        '.username': 'usernameContainer',
        '.login-form': 'loginFormContainer',
        '.favorites ul': 'favoritesList',
        '.recents ul': 'recentsList',
        '.groups ul': 'groupsList'
      };

      Profile.prototype.recentsPage = 1;

      Profile.prototype.favoritesPage = 1;

      function Profile() {
        this.loadMoreFavorites = __bind(this.loadMoreFavorites, this);

        this.loadMoreRecents = __bind(this.loadMoreRecents, this);

        this.onFavoriteDeleteClick = __bind(this.onFavoriteDeleteClick, this);

        this.signOut = __bind(this.signOut, this);

        this.updateRecents = __bind(this.updateRecents, this);

        this.recentTemplate = __bind(this.recentTemplate, this);

        this.updateFavorites = __bind(this.updateFavorites, this);

        this.favoriteTemplate = __bind(this.favoriteTemplate, this);

        this.userChanged = __bind(this.userChanged, this);
        Profile.__super__.constructor.apply(this, arguments);
        this.html(this.template);
        this.loginForm = new LoginForm({
          el: this.loginFormContainer
        });
        User.bind('sign-in', this.userChanged);
        User.bind('add-favorite remove-favorite', this.updateFavorites);
        User.bind('add-recent remove-recent', this.updateRecents);
        delay(this.userChanged);
      }

      Profile.prototype.userChanged = function() {
        this.el.toggleClass('signed-in', User.current != null);
        if (User.current != null) {
          this.usernameContainer.html(User.current.name);
          Favorite.refresh();
          return Recent.refresh();
        }
      };

      Profile.prototype.favoriteTemplate = function(favorite) {
        return "<li>" + favorite.createdAt + "</li>";
      };

      Profile.prototype.updateFavorites = function() {
        var favorite, favorites, _i, _len, _results;
        this.favoritesList.empty();
        favorites = User.current.favorites;
        this.el.toggleClass('has-favorites', favorites.length > 0);
        _results = [];
        for (_i = 0, _len = favorites.length; _i < _len; _i++) {
          favorite = favorites[_i];
          _results.push(this.favoritesList.prepend(this.favoriteTemplate(favorite)));
        }
        return _results;
      };

      Profile.prototype.recentTemplate = function(recent) {
        return "<li>" + recent.subjects[0].location + "</li>";
      };

      Profile.prototype.updateRecents = function() {
        var recent, recents, _i, _len, _results;
        this.recentsList.empty();
        recents = User.current.recents;
        this.el.toggleClass('has-recents', recents.length > 0);
        _results = [];
        for (_i = 0, _len = recents.length; _i < _len; _i++) {
          recent = recents[_i];
          _results.push(this.recentsList.prepend(this.recentTemplate(recent)));
        }
        return _results;
      };

      Profile.prototype.signOut = function(e) {
        e.preventDefault();
        return User.deauthenticate();
      };

      Profile.prototype.onFavoriteDeleteClick = function(e) {
        var f, favorite, favoriteID, target;
        target = $(e.target);
        favoriteID = target.data('favorite');
        favorite = ((function() {
          var _i, _len, _ref, _results;
          _ref = User.current.favorites;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            f = _ref[_i];
            if (f.id === favoriteID) {
              _results.push(f);
            }
          }
          return _results;
        })())[0];
        favorite.destroy(true);
        target.parent('li').remove();
        return e != null ? typeof e.preventDefault === "function" ? e.preventDefault() : void 0 : void 0;
      };

      Profile.prototype.loadMoreRecents = function() {
        this.recentsPage += 1;
        return Recent.refresh({
          page: this.recentsPage
        });
      };

      Profile.prototype.loadMoreFavorites = function() {
        this.favoritesPage += 1;
        return Favorite.refresh({
          page: this.favoritesPage
        });
      };

      return Profile;

    })(Spine.Controller);
    return module.exports = Profile;
  });

}).call(this);