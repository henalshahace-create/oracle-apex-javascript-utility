-- =================================================================
-- Oracle APEX REST Web Service Handler
-- Purpose: Consume external JSON endpoints using APEX_WEB_SERVICE
-- =================================================================

CREATE OR REPLACE PACKAGE apex_rest_pkg AS
    PROCEDURE fetch_and_store_data(
        p_endpoint_url IN VARCHAR2
    );
END apex_rest_pkg;
/

CREATE OR REPLACE PACKAGE BODY apex_rest_pkg AS

    PROCEDURE fetch_and_store_data(
        p_endpoint_url IN VARCHAR2
    ) IS
        l_response CLOB;
    BEGIN
        -- Set Request Headers for JSON API
        apex_web_service.g_request_headers(1).name  := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/json';

        -- Execute GET Request
        l_response := apex_web_service.make_rest_request(
            p_url         => p_endpoint_url,
            p_http_method => 'GET'
        );

        -- Log status using standard APEX debug messaging
        IF apex_web_service.g_status_code = 200 THEN
            apex_debug.message('REST Request successful. Response length: %s', DBMS_LOB.GETLENGTH(l_response));
        ELSE
            apex_debug.error('REST Request failed with HTTP status: %s', apex_web_service.g_status_code);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            apex_debug.error('Unhandled error in fetch_and_store_data: %s', SQLERRM);
            RAISE;
    END fetch_and_store_data;

END apex_rest_pkg;
/
