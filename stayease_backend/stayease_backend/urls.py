from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from bookings.views import HotelViewSet, BookingViewSet

from bookings.views import register_user
from rest_framework_simplejwt.views import TokenObtainPairView

router = DefaultRouter()
router.register(r'hotels', HotelViewSet)
router.register(r'bookings', BookingViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('api/register/', register_user),
    path('api/login/', TokenObtainPairView.as_view()),
]