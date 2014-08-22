
// Permissions

// user:                Defaults to Meteor.user()
// returnError:         If there's an error, should we return what the problem is?
//
// return true if all is well, false || an error string if not
canView = function(user){
  var user=(typeof user === 'undefined') ? Meteor.user() : user;
  return !!user;
};

canViewById     = canView;
canPost         = canView;
canPostById     = canView;
canComment      = canView;
canCommentById  = canView;
canUpvote       = canView;
canUpvoteById   = canView;
canDownvote     = canView;
canDownvoteById = canView;

canEdit = function(user, item, returnError){
  var user=(typeof user === 'undefined') ? Meteor.user() : user;

  if (!user || !item){
    return returnError ? "no_rights" : false;
  } else if (isAdmin(user)) {
    return true;
  } else if (user._id!==item.userId) {
    return returnError ? "no_rights" : false;
  }else {
    return true;
  }
};

canEditById = function(userId, item){
  var user = Meteor.users.findOne(userId);
  return canEdit(user, item);
};
currentUserCanEdit = function(item) {
  return canEdit(Meteor.user(), item);
};

canInvite = function(user){
  return false;
};