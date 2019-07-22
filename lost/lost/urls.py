from django.urls import path
from .views import *

urlpatterns = [
    path("product/", ProductLView.as_view()),
    path("product/create/", ProductCView.as_view()),
    path("comment/", CommentListView.as_view()),
    path("comment/create/", CommentCView.as_view()),
    path("detail/<int:pk>/", ProductDetialView.as_view())
]