import logging

# Data
SQLALCHEMY_DATABASE_URI = 'sqlite:///portfolio.db'

# Cache
CACHE_TYPE = "SimpleCache"
CACHE_DEFAULT_TIMEOUT = 240

# Secrets
SECRET_KEY = b'5JN_n6oRXtK2hcp0TVMF59Pzcbc'

CSRF_MINUTES = 10
CSRF_SECRET = b'zYxKxs39RsZ2Xs7EvPXuU6AfON4'

# Portfolio
PORTFOLIO_NIVEAU_LOG = logging.INFO

PORTFOLIO_DATE_FORMAT = '%d/%m/%y %H:%M'

PORTFOLIO_ADMIN_MAXCONTACT = 20

PORTFOLIO_INFO_PERSO = ['@', 'http', 'adresse', 'téléphone', 'tel', 'tél']

PORTFOLIO_LIKES_PERIODE = 2000

# Flask security

SECURITY_PASSWORD_SALT = 'xN2u_h0hvNWjs6-wK_OrmXWcMjM'
SECURITY_URL_PREFIX = '/auth'
SECURITY_POST_LOGIN_VIEW = 'client.index'

JWT_SECRET_KEY = 'gQIMqYOBmexDajlJJlGGuEtPXgo'

BABEL_DEFAULT_LOCALE = 'fr'

ADMIN_MAIL = 'a@b.c'
ADMIN_PASSE_INITIAL = 'abc'
ADMIN_LOGO = 'img/logos/integration.png'

SECURITY_TRACKABLE = True
SECURITY_CHANGEABLE = True

# Serveur SMTP nécessaire
SECURITY_REGISTERABLE = False
SECURITY_CONFIRMABLE = False
SECURITY_RECOVERABLE = False

MAIL_SERVER = 'smtp.example.com'
MAIL_PORT = 587
MAIL_USE_TLS = True
MAIL_USERNAME = 'username'
MAIL_PASSWORD = 'password'

# Développement avancé
SECURITY_TWO_FACTOR = False
SECURITY_UNIFIED_SIGNIN = False
SECURITY_WEBAUTHN = False
SECURITY_MULTI_FACTOR_RECOVERY_CODES = False
SECURITY_OAUTH_ENABLE = False
