set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.3.00.03'
,p_default_workspace_id=>42937890966776491
,p_default_application_id=>600
,p_default_owner=>'APEX_PLUGIN'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/de_danielh_apexscreencapture
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(20905356408423373797)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.DANIELH.APEXSCREENCAPTURE'
,p_display_name=>'APEX Screen Capture'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * APEX Screen Capture functions',
' * Version: 1.5 (05.01.2016)',
' * Author:  Daniel Hochleitner',
' *-------------------------------------',
'*/',
'FUNCTION render_screencapture(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                              p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result IS',
'  --',
'  -- plugin attributes',
'  l_result           apex_plugin.t_dynamic_action_render_result;',
'  l_html_elem        VARCHAR2(200) := p_dynamic_action.attribute_01;',
'  l_open_window      VARCHAR2(10) := p_dynamic_action.attribute_02;',
'  l_plsql            p_dynamic_action.attribute_03%TYPE := p_dynamic_action.attribute_03;',
'  l_background       VARCHAR2(10) := p_dynamic_action.attribute_04;',
'  l_width            NUMBER := p_dynamic_action.attribute_05;',
'  l_height           NUMBER := p_dynamic_action.attribute_06;',
'  l_letter_rendering VARCHAR2(50) := p_dynamic_action.attribute_07;',
'  l_allow_taint      VARCHAR2(50) := p_dynamic_action.attribute_08;',
'  l_logging          VARCHAR2(50) := p_dynamic_action.attribute_09;',
'  l_dom_selector     VARCHAR2(50) := p_dynamic_action.attribute_10;',
'  l_dom_filter       VARCHAR2(100) := p_dynamic_action.attribute_11;',
'  l_dom_hidelabel    VARCHAR2(50) := p_dynamic_action.attribute_12;',
'  l_dom_fillcontent  VARCHAR2(50) := p_dynamic_action.attribute_13;',
'  l_border_color     VARCHAR2(50) := p_dynamic_action.attribute_14;',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'  -- add html2canvas js / screencapture js / jquery dom outline js (and promise for older browsers)',
'  apex_javascript.add_library(p_name           => ''es6-promise.min'',',
'                              p_directory      => p_plugin.file_prefix,',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
'',
'  --',
'  apex_javascript.add_library(p_name           => ''html2canvas.min'',',
'                              p_directory      => p_plugin.file_prefix,',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
'  -- only when Dom selector is enabled',
'  IF l_dom_selector = ''Y'' THEN',
'    apex_javascript.add_library(p_name           => ''jquery.dom-outline-1.0'',',
'                                p_directory      => p_plugin.file_prefix,',
'                                p_version        => NULL,',
'                                p_skip_extension => FALSE);',
'  END IF;',
'  --',
'  apex_javascript.add_library(p_name           => ''apexscreencapture'',',
'                              p_directory      => p_plugin.file_prefix,',
'                              p_version        => NULL,',
'                              p_skip_extension => FALSE);',
'  -- attribute defaults',
'  l_open_window      := nvl(l_open_window,',
'                            ''Y'');',
'  l_dom_selector     := nvl(l_dom_selector,',
'                            ''N'');',
'  l_letter_rendering := nvl(l_letter_rendering,',
'                            ''false'');',
'  l_allow_taint      := nvl(l_allow_taint,',
'                            ''false'');',
'  l_dom_hidelabel    := nvl(l_dom_hidelabel,',
'                            ''false'');',
'  l_dom_fillcontent  := nvl(l_dom_fillcontent,',
'                            ''false'');',
'  l_border_color     := nvl(l_border_color,',
'                            ''#09c'');',
'  l_logging          := nvl(l_logging,',
'                            ''false'');',
'  --',
'  --',
'  l_result.javascript_function := ''captureScreen'';',
'  l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;',
'  l_result.attribute_01        := l_html_elem;',
'  l_result.attribute_02        := l_open_window;',
'  l_result.attribute_03        := l_plsql;',
'  l_result.attribute_04        := l_background;',
'  l_result.attribute_05        := l_width;',
'  l_result.attribute_06        := l_height;',
'  l_result.attribute_07        := l_letter_rendering;',
'  l_result.attribute_08        := l_allow_taint;',
'  l_result.attribute_09        := l_logging;',
'  l_result.attribute_10        := l_dom_selector;',
'  l_result.attribute_11        := l_dom_filter;',
'  l_result.attribute_12        := l_dom_hidelabel;',
'  l_result.attribute_13        := l_dom_fillcontent;',
'  l_result.attribute_14        := l_border_color;',
'  --',
'  RETURN l_result;',
'  --',
'END render_screencapture;',
'--',
'--',
'-- AJAX function',
'--',
'--',
'FUNCTION ajax_screencapture(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                            p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_ajax_result IS',
'  --',
'  -- plugin attributes',
'  l_result apex_plugin.t_dynamic_action_ajax_result;',
'  l_plsql  p_dynamic_action.attribute_03%TYPE := p_dynamic_action.attribute_03;',
'  --',
'BEGIN',
'  -- execute PL/SQL',
'  apex_plugin_util.execute_plsql_code(p_plsql_code => l_plsql);',
'  --',
'  --',
'  RETURN l_result;',
'  --',
'END ajax_screencapture;'))
,p_render_function=>'render_screencapture'
,p_ajax_function=>'ajax_screencapture'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'This plugin allows you to take "screenshots/captures" of pages or parts of it, directly on the users browser.<br>',
'The screenshot is based on the DOM and as such may not be 100% accurate to the real representation as it does not make an actual screenshot, but builds the screenshot based on the information available on the page.'))
,p_version_identifier=>'1.5'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-apexscreencapture'
,p_files_version=>357
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20907865192844889141)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'JQuery Selector'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'body'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'body - for complete document<br>',
'#my_div - for capturing only a DIV<br>',
'.my_class - for capturing only a region with a specific class'))
,p_help_text=>'Enter the JQuery Selector that should be captured.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908001439074907820)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Open image in new tab (or save to DB)'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Choose whether the image should be opened in a new window or saved to DB using PL/SQL (for BLOBs).<br>',
'Y - New Tab<br>',
'N - Save to DB using PL/SQL code'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908077641491749223)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'PLSQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'DECLARE',
'  --',
'  l_collection_name VARCHAR2(100);',
'  l_clob            CLOB;',
'  l_clob_base64     CLOB;',
'  l_blob            BLOB;',
'  l_filename        VARCHAR2(100);',
'  l_mime_type       VARCHAR2(100);',
'  --',
'BEGIN',
'  -- get defaults',
'  l_collection_name := ''SCREEN_CAPTURE'';',
'  l_filename        := ''screenshot_'' ||',
'                       to_char(SYSDATE,',
'                               ''YYYYMMDDHH24MISS'') || ''.png'';',
'  l_mime_type       := ''image/png'';',
'  -- get CLOB from APEX special collection',
'  SELECT clob001',
'    INTO l_clob',
'    FROM apex_collections',
'   WHERE collection_name = ''CLOB_CONTENT'';',
'  --',
'  -- escape special chars',
'  l_clob_base64 := REPLACE(REPLACE(REPLACE(REPLACE(l_clob,',
'                                                   chr(10),',
'                                                   ''''),',
'                                           chr(13),',
'                                           ''''),',
'                                   chr(9),',
'                                   ''''),',
'                           ''data:image/png;base64,'',',
'                           '''');',
'  -- convert base64 CLOB to BLOB (mimetype: image/png)',
'  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob_base64);',
'  --',
'  -- create own collection',
'  -- check if exist',
'  IF NOT',
'      apex_collection.collection_exists(p_collection_name => l_collection_name) THEN',
'    apex_collection.create_collection(l_collection_name);',
'  END IF;',
'  -- add collection member (only if BLOB not null)',
'  IF dbms_lob.getlength(lob_loc => l_blob) IS NOT NULL THEN',
'    apex_collection.add_member(p_collection_name => l_collection_name,',
'                               p_c001            => l_filename, -- filename',
'                               p_c002            => l_mime_type, -- mime_type',
'                               p_d001            => SYSDATE, -- date created',
'                               p_blob001         => l_blob); -- BLOB img content',
'  END IF;',
'  --',
'END;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(20908001439074907820)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'SELECT c001    AS filename,<br>',
'       c002    AS mime_type,<br>',
'       d001    AS date_created,<br>',
'       blob001 AS img_content<br>',
'  FROM apex_collections<br>',
' WHERE collection_name = ''SCREEN_CAPTURE'';'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'PLSQL code which saves the image to database tables or collections.<br>',
'Default to Collection "SCREEN_CAPTURE".<br>',
'Column c001 => filename<br>',
'Column c002 => mime_type<br>',
'Column d001 => date created<br>',
'Column blob001 => BLOB of image<br>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908084797064754728)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Background color'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'#fff'
,p_is_translatable=>false
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Background color of the captured image (In Hex with # in front).<br>',
'Canvas background color, if none is specified in DOM. Set undefined for transparent.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908044888411923800)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Width'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_help_text=>'Width in pixels'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908045806197925970)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Height'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_help_text=>'Height in pixels'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908168727738764871)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Letter rendering'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Whether to render each letter separately'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(20908173282279766442)
,p_plugin_attribute_id=>wwv_flow_api.id(20908168727738764871)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(20908173666676767301)
,p_plugin_attribute_id=>wwv_flow_api.id(20908168727738764871)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908217860547774684)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Allow taint'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Whether to allow cross-origin images to taint the canvas'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(20908220382195776188)
,p_plugin_attribute_id=>wwv_flow_api.id(20908217860547774684)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(20908229293384943638)
,p_plugin_attribute_id=>wwv_flow_api.id(20908217860547774684)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20908226561746782112)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Logging'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'false'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Whether to log events in the console.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(20908247495042949800)
,p_plugin_attribute_id=>wwv_flow_api.id(20908226561746782112)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(20908257851183784947)
,p_plugin_attribute_id=>wwv_flow_api.id(20908226561746782112)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21774379918335858540)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>5
,p_prompt=>'DOM UI Selector'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Choose if a graphical selector should be used or not.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21842185481828031257)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>6
,p_prompt=>'DOM Filter'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'div'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'for all divs: div<br>',
'for all divs with a ID attribute: div[id]'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'A selector that an element should match in order to be outlined and clicked. Default is ''div''.<br>',
'No value means no filter is enabled and all elements would be outlined.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21842198818357035514)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>7
,p_prompt=>'Hide Label'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>'Shows a label above the visual indicator. The label contains the element''s name, id, class name, and dimensions.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(21842201573265036464)
,p_plugin_attribute_id=>wwv_flow_api.id(21842198818357035514)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(21842208330401037790)
,p_plugin_attribute_id=>wwv_flow_api.id(21842198818357035514)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21858169594504176065)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>9
,p_prompt=>'Selector Fill Content'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'false'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>'Whether the content of a selected area is filled with color or not.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(21858154801031343392)
,p_plugin_attribute_id=>wwv_flow_api.id(21858169594504176065)
,p_display_sequence=>10
,p_display_value=>'True'
,p_return_value=>'true'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(21858155717618344843)
,p_plugin_attribute_id=>wwv_flow_api.id(21858169594504176065)
,p_display_sequence=>20
,p_display_value=>'False'
,p_return_value=>'false'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(21886359420493483047)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>8
,p_prompt=>'Selector Border Color'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'#09c'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(21774379918335858540)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Color of the DOM selector outline (In Hex with # in front).<br>',
'If fill content is chosen, this color is 30% darker and transparent.'))
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E207061727365426F6F6C65616E2870537472696E6729207B0A20207661722070426F6F6C65616E3B0A20206966202870537472696E672E746F4C6F776572436173652829203D3D2027747275652729207B0A2020202070426F6F6C65';
wwv_flow_api.g_varchar2_table(2) := '616E203D20747275653B0A20207D0A20206966202870537472696E672E746F4C6F776572436173652829203D3D202766616C73652729207B0A2020202070426F6F6C65616E203D2066616C73653B0A20207D0A202069662028212870537472696E672E74';
wwv_flow_api.g_varchar2_table(3) := '6F4C6F776572436173652829203D3D202774727565272920262620212870537472696E672E746F4C6F776572436173652829203D3D202766616C7365272929207B0A2020202070426F6F6C65616E203D20756E646566696E65643B0A20207D0A20207265';
wwv_flow_api.g_varchar2_table(4) := '7475726E2070426F6F6C65616E3B0A7D0A0A66756E6374696F6E2073657441706578436F6C6C656374696F6E436C6F6220287042696756616C75652C2063616C6C6261636B29207B0A20207661722061706578416A61784F626A203D206E657720617065';
wwv_flow_api.g_varchar2_table(5) := '782E616A61782E636C6F6220280A202066756E6374696F6E2829207B0A20202020766172207273203D20702E726561647953746174653B0A20202020696620287273203D3D203429207B0A20202020202063616C6C6261636B28293B0A202020207D2065';
wwv_flow_api.g_varchar2_table(6) := '6C7365207B0A20202020202072657475726E2066616C73653B0A202020207D3B0A20207D293B0A202061706578416A61784F626A2E5F736574287042696756616C7565293B0A7D0A0A66756E6374696F6E20676574496D61676528616A61784964656E74';
wwv_flow_api.g_varchar2_table(7) := '69666965722C63616E7661732C6F70656E57696E646F7729207B0A202076617220696D67202020203D2063616E7661732E746F4461746155524C2822696D6167652F706E6722293B0A2020696620286F70656E57696E646F77203D3D2027592729207B0A';
wwv_flow_api.g_varchar2_table(8) := '20202020696620286E6176696761746F722E76656E646F722E696E6465784F6628224170706C6522293D3D30202626202F5C735361666172695C2F2F2E74657374286E6176696761746F722E757365724167656E742929207B0A20202020202077696E64';
wwv_flow_api.g_varchar2_table(9) := '6F772E6C6F636174696F6E2E68726566203D20696D673B0A202020207D20656C7365207B0A2020202077696E646F772E6F70656E28696D672C275F626C616E6B27293B0A202020207D0A20207D20656C7365207B0A2020202073657441706578436F6C6C';
wwv_flow_api.g_varchar2_table(10) := '656374696F6E436C6F622028696D672C2066756E6374696F6E28297B617065782E7365727665722E706C7567696E28616A61784964656E7469666965722C207B0A2020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(11) := '2020202020202020207830313A2027270A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020207D2C7B64617461547970653A2027786D6C277D293B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(12) := '20202020202020202020202020202020202020202020202020207D290A20207D0A7D0A0A66756E6374696F6E20646F68746D6C3263616E766173287068746D6C456C656D2C706F70656E57696E646F772C70416A61784964656E7469666965722C706261';
wwv_flow_api.g_varchar2_table(13) := '636B67726F756E642C7077696474682C706865696768742C706C657474657252656E646572696E672C70616C6C6F775461696E742C706C6F6767696E6729207B0A20202F2F204C6F6767696E670A202069662028706C6F6767696E6729207B0A20202020';
wwv_flow_api.g_varchar2_table(14) := '636F6E736F6C652E6C6F672827646F68746D6C3263616E7661733A2048544D4C20656C656D656E743A272C7068746D6C456C656D293B0A20202020636F6E736F6C652E6C6F672827646F68746D6C3263616E7661733A20656C656D656E74207769647468';
wwv_flow_api.g_varchar2_table(15) := '3A272C707769647468293B0A20202020636F6E736F6C652E6C6F672827646F68746D6C3263616E7661733A20656C656D656E74206865696768743A272C70686569676874293B0A20207D0A20202F2F2068746D6C3263616E7661730A202068746D6C3263';
wwv_flow_api.g_varchar2_table(16) := '616E7661732824287068746D6C456C656D292C207B0A202020206F6E72656E64657265643A2066756E6374696F6E2863616E76617329207B0A202020202020676574496D6167652870416A61784964656E7469666965722C63616E7661732C706F70656E';
wwv_flow_api.g_varchar2_table(17) := '57696E646F77293B0A202020207D2C0A202020206261636B67726F756E64203A20706261636B67726F756E642C0A2020202077696474683A207077696474682C0A202020206865696768743A20706865696768742C0A202020206C657474657252656E64';
wwv_flow_api.g_varchar2_table(18) := '6572696E67203A20706C657474657252656E646572696E672C0A20202020616C6C6F775461696E74203A2070616C6C6F775461696E742C0A202020206C6F6767696E67203A20706C6F6767696E670A20207D293B0A7D0A0A66756E6374696F6E20646F68';
wwv_flow_api.g_varchar2_table(19) := '746D6C3263616E766173446F6D2870456C656D656E742C706F70656E57696E646F772C70416A61784964656E7469666965722C706261636B67726F756E642C706C657474657252656E646572696E672C70616C6C6F775461696E742C706C6F6767696E67';
wwv_flow_api.g_varchar2_table(20) := '29207B0A20202F2F20506172616D657465720A202020206966202870456C656D656E742E696429207B0A2020202020207068746D6C456C656D203D20272327202B2070456C656D656E742E69643B0A202020207D20656C7365207B0A2020202020206966';
wwv_flow_api.g_varchar2_table(21) := '202870456C656D656E742E636C6173734E616D6529207B0A20202020202020207068746D6C456C656D203D2070456C656D656E742E7461674E616D652E746F4C6F7765724361736528293B0A20202020202020207068746D6C456C656D202B3D2028272E';
wwv_flow_api.g_varchar2_table(22) := '27202B206A51756572792E7472696D2870456C656D656E742E636C6173734E616D65292E7265706C616365282F202F672C20272E2729292E7265706C616365282F5C2E5C2E2B2F672C20272E27293B0A2020202020207D0A202020207D0A202070776964';
wwv_flow_api.g_varchar2_table(23) := '7468202020203D20242870456C656D656E74292E776964746828293B0A2020706865696768742020203D20242870456C656D656E74292E68656967687428293B0A20202F2F204C6F6767696E670A202069662028706C6F6767696E6729207B0A20202020';
wwv_flow_api.g_varchar2_table(24) := '636F6E736F6C652E6C6F672827646F68746D6C3263616E766173446F6D3A2048544D4C20656C656D656E743A272C7068746D6C456C656D293B0A20202020636F6E736F6C652E6C6F672827646F68746D6C3263616E766173446F6D3A20656C656D656E74';
wwv_flow_api.g_varchar2_table(25) := '2077696474683A272C707769647468293B0A20202020636F6E736F6C652E6C6F672827646F68746D6C3263616E766173446F6D3A20656C656D656E74206865696768743A272C70686569676874293B0A20202020636F6E736F6C652E6C6F672827646F68';
wwv_flow_api.g_varchar2_table(26) := '746D6C3263616E766173446F6D3A20436C69636B656420656C656D656E743A272C2070456C656D656E74293B0A20207D0A20202F2F2068746D6C3263616E7661730A202068746D6C3263616E7661732824287068746D6C456C656D292C207B0A20202020';
wwv_flow_api.g_varchar2_table(27) := '6F6E72656E64657265643A2066756E6374696F6E2863616E76617329207B0A202020202020676574496D6167652870416A61784964656E7469666965722C63616E7661732C706F70656E57696E646F77293B0A202020207D2C0A202020206261636B6772';
wwv_flow_api.g_varchar2_table(28) := '6F756E64203A20706261636B67726F756E642C0A2020202077696474683A207077696474682C0A202020206865696768743A20706865696768742C0A202020206C657474657252656E646572696E67203A20706C657474657252656E646572696E672C0A';
wwv_flow_api.g_varchar2_table(29) := '20202020616C6C6F775461696E74203A2070616C6C6F775461696E742C0A202020206C6F6767696E67203A20706C6F6767696E670A20207D293B0A7D0A0A66756E6374696F6E206361707475726553637265656E2829207B0A20202F2F20706C7567696E';
wwv_flow_api.g_varchar2_table(30) := '20617474726962757465730A20207661722064615468697320202020202020202020202020203D20746869733B0A20207661722076416A61784964656E74696669657220202020203D206461546869732E616374696F6E2E616A61784964656E74696669';
wwv_flow_api.g_varchar2_table(31) := '65723B0A2020766172207668746D6C456C656D20202020202020202020203D206461546869732E616374696F6E2E61747472696275746530313B0A202076617220766F70656E57696E646F772020202020202020203D206461546869732E616374696F6E';
wwv_flow_api.g_varchar2_table(32) := '2E61747472696275746530323B0A202076617220766261636B67726F756E642020202020202020203D206461546869732E616374696F6E2E61747472696275746530343B0A20207661722076776964746820202020202020202020202020203D20706172';
wwv_flow_api.g_varchar2_table(33) := '7365496E74286461546869732E616374696F6E2E6174747269627574653035293B0A20207661722076686569676874202020202020202020202020203D207061727365496E74286461546869732E616374696F6E2E6174747269627574653036293B0A20';
wwv_flow_api.g_varchar2_table(34) := '2076617220766C657474657252656E646572696E67202020203D207061727365426F6F6C65616E286461546869732E616374696F6E2E6174747269627574653037293B0A20207661722076616C6C6F775461696E742020202020202020203D2070617273';
wwv_flow_api.g_varchar2_table(35) := '65426F6F6C65616E286461546869732E616374696F6E2E6174747269627574653038293B0A202076617220766C6F6767696E672020202020202020202020203D207061727365426F6F6C65616E286461546869732E616374696F6E2E6174747269627574';
wwv_flow_api.g_varchar2_table(36) := '653039293B0A20207661722076646F6D53656C6563746F7220202020202020203D206461546869732E616374696F6E2E61747472696275746531303B0A20207661722076646F6D46696C746572202020202020202020203D206461546869732E61637469';
wwv_flow_api.g_varchar2_table(37) := '6F6E2E61747472696275746531313B0A20207661722076646F6D686964654C6162656C202020202020203D207061727365426F6F6C65616E286461546869732E616374696F6E2E6174747269627574653132293B0A20207661722076646F6D66696C6C43';
wwv_flow_api.g_varchar2_table(38) := '6F6E74656E7420202020203D207061727365426F6F6C65616E286461546869732E616374696F6E2E6174747269627574653133293B0A20207661722076646F6D626F72646572436F6C6F7220202020203D206461546869732E616374696F6E2E61747472';
wwv_flow_api.g_varchar2_table(39) := '696275746531343B0A20202F2F206465766963652077696474682F6865696768740A202076617220636C69656E74576964746820203D207061727365496E7428646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E745769647468';
wwv_flow_api.g_varchar2_table(40) := '293B0A202076617220636C69656E74486569676874203D207061727365496E7428646F63756D656E742E646F63756D656E74456C656D656E742E636C69656E74486569676874293B0A202069662028767769647468203D3D206E756C6C207C7C20767769';
wwv_flow_api.g_varchar2_table(41) := '647468203D3D20756E646566696E6564207C7C2069734E614E287061727365466C6F617428767769647468292929207B0A20202020767769647468203D20636C69656E7457696474683B0A20207D0A20206966202876686569676874203D3D206E756C6C';
wwv_flow_api.g_varchar2_table(42) := '207C7C2076686569676874203D3D20756E646566696E6564207C7C2069734E614E287061727365466C6F61742876686569676874292929207B0A2020202076686569676874203D20636C69656E744865696768743B0A20207D0A20202F2F206465666175';
wwv_flow_api.g_varchar2_table(43) := '6C747320666F7220444F4D204F75746C696E65720A20206966202876646F6D46696C746572203D3D206E756C6C207C7C2076646F6D46696C746572203D3D20756E646566696E656429207B0A2020202076646F6D46696C746572203D2066616C73653B0A';
wwv_flow_api.g_varchar2_table(44) := '20207D0A20206966202876646F6D686964654C6162656C203D3D206E756C6C207C7C2076646F6D686964654C6162656C203D3D20756E646566696E656429207B0A2020202076646F6D686964654C6162656C203D2066616C73653B0A20207D0A20206966';
wwv_flow_api.g_varchar2_table(45) := '202876646F6D66696C6C436F6E74656E74203D3D206E756C6C207C7C2076646F6D66696C6C436F6E74656E74203D3D20756E646566696E656429207B0A2020202076646F6D66696C6C436F6E74656E74203D2066616C73653B0A20207D0A20202F2F204C';
wwv_flow_api.g_varchar2_table(46) := '6F6767696E670A202069662028766C6F6767696E6729207B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A20417474726962757465204A51756572792073656C6563746F723A272C7668746D6C456C656D293B0A202020';
wwv_flow_api.g_varchar2_table(47) := '20636F6E736F6C652E6C6F6728276361707475726553637265656E3A20417474726962757465206F70656E2077696E646F773A272C766F70656E57696E646F77293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A2041';
wwv_flow_api.g_varchar2_table(48) := '7474726962757465206261636B67726F756E643A272C766261636B67726F756E64293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A2041747472696275746520656C656D656E742077696474683A272C767769647468';
wwv_flow_api.g_varchar2_table(49) := '293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A2041747472696275746520656C656D656E74206865696768743A272C76686569676874293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265';
wwv_flow_api.g_varchar2_table(50) := '656E3A20417474726962757465206C65747465722072656E646572696E673A272C766C657474657252656E646572696E67293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A2041747472696275746520616C6C6F7720';
wwv_flow_api.g_varchar2_table(51) := '7461696E743A272C76616C6C6F775461696E74293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A20417474726962757465204C6F6767696E673A272C766C6F6767696E67293B0A20202020636F6E736F6C652E6C6F67';
wwv_flow_api.g_varchar2_table(52) := '28276361707475726553637265656E3A2041747472696275746520444F4D2073656C6563746F723A272C76646F6D53656C6563746F72293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A204174747269627574652044';
wwv_flow_api.g_varchar2_table(53) := '4F4D2066696C7465723A272C76646F6D46696C746572293B0A20202020636F6E736F6C652E6C6F6728276361707475726553637265656E3A204174747269627574652068696465206C6162656C3A272C76646F6D686964654C6162656C293B0A20202020';
wwv_flow_api.g_varchar2_table(54) := '636F6E736F6C652E6C6F6728276361707475726553637265656E3A204174747269627574652066696C6C20636F6E74656E743A272C76646F6D66696C6C436F6E74656E74293B0A20202020636F6E736F6C652E6C6F672827636170747572655363726565';
wwv_flow_api.g_varchar2_table(55) := '6E3A2041747472696275746520626F7264657220636F6C6F723A272C76646F6D626F72646572436F6C6F72293B0A20207D0A20206966202876646F6D53656C6563746F72203D3D2027592729207B0A20202F2F2068746D6C3263616E7661732077697468';
wwv_flow_api.g_varchar2_table(56) := '20444F4D204F75746C696E65720A2020766172206D79436C69636B48616E646C6572203D2066756E6374696F6E2028656C656D656E7429207B20646F68746D6C3263616E766173446F6D28656C656D656E742C766F70656E57696E646F772C76416A6178';
wwv_flow_api.g_varchar2_table(57) := '4964656E7469666965722C766261636B67726F756E642C766C657474657252656E646572696E672C76616C6C6F775461696E742C766C6F6767696E67293B207D0A2020766172206D79446F6D4F75746C696E65203D20446F6D4F75746C696E65287B0A20';
wwv_flow_api.g_varchar2_table(58) := '2020206F6E436C69636B3A206D79436C69636B48616E646C65722C0A2020202066696C7465723A2076646F6D46696C7465722C0A2020202073746F704F6E436C69636B3A20747275652C0A20202020626F72646572436F6C6F723A2076646F6D626F7264';
wwv_flow_api.g_varchar2_table(59) := '6572436F6C6F722C0A20202020686964654C6162656C3A2076646F6D686964654C6162656C2C0A2020202066696C6C436F6E74656E743A2076646F6D66696C6C436F6E74656E740A20207D293B0A20206D79446F6D4F75746C696E652E73746172742829';
wwv_flow_api.g_varchar2_table(60) := '3B0A20207D20656C7365207B0A20202F2F2068746D6C3263616E7661730A2020646F68746D6C3263616E766173287668746D6C456C656D2C766F70656E57696E646F772C76416A61784964656E7469666965722C766261636B67726F756E642C76776964';
wwv_flow_api.g_varchar2_table(61) := '74682C766865696768742C766C657474657252656E646572696E672C76616C6C6F775461696E742C766C6F6767696E67293B0A20207D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(20907749649343852845)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_file_name=>'apexscreencapture.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202068746D6C3263616E76617320302E352E302D6265746132203C687474703A2F2F68746D6C3263616E7661732E686572747A656E2E636F6D3E0A2020436F70797269676874202863292032303135204E696B6C617320766F6E20486572747A65';
wwv_flow_api.g_varchar2_table(2) := '6E0A0A202052656C656173656420756E64657220204C6963656E73650A2A2F0A2166756E6374696F6E2861297B696628226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C65';
wwv_flow_api.g_varchar2_table(3) := '296D6F64756C652E6578706F7274733D6128293B656C7365206966282266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D6429646566696E65285B5D2C61293B656C73657B76617220623B623D22756E646566696E';
wwv_flow_api.g_varchar2_table(4) := '656422213D747970656F662077696E646F773F77696E646F773A22756E646566696E656422213D747970656F6620676C6F62616C3F676C6F62616C3A22756E646566696E656422213D747970656F662073656C663F73656C663A746869732C622E68746D';
wwv_flow_api.g_varchar2_table(5) := '6C3263616E7661733D6128297D7D2866756E6374696F6E28297B76617220613B72657475726E2066756E6374696F6E206228612C632C64297B66756E6374696F6E206528672C68297B69662821635B675D297B69662821615B675D297B76617220693D22';
wwv_flow_api.g_varchar2_table(6) := '66756E6374696F6E223D3D747970656F6620726571756972652626726571756972653B69662821682626692972657475726E206928672C2130293B696628662972657475726E206628672C2130293B766172206A3D6E6577204572726F72282243616E6E';
wwv_flow_api.g_varchar2_table(7) := '6F742066696E64206D6F64756C652027222B672B222722293B7468726F77206A2E636F64653D224D4F44554C455F4E4F545F464F554E44222C6A7D766172206B3D635B675D3D7B6578706F7274733A7B7D7D3B615B675D5B305D2E63616C6C286B2E6578';
wwv_flow_api.g_varchar2_table(8) := '706F7274732C66756E6374696F6E2862297B76617220633D615B675D5B315D5B625D3B72657475726E206528633F633A62297D2C6B2C6B2E6578706F7274732C622C612C632C64297D72657475726E20635B675D2E6578706F7274737D666F7228766172';
wwv_flow_api.g_varchar2_table(9) := '20663D2266756E6374696F6E223D3D747970656F6620726571756972652626726571756972652C673D303B673C642E6C656E6774683B672B2B296528645B675D293B72657475726E20657D287B313A5B66756E6374696F6E28622C632C64297B2866756E';
wwv_flow_api.g_varchar2_table(10) := '6374696F6E2862297B2166756E6374696F6E2865297B66756E6374696F6E20662861297B7468726F772052616E67654572726F7228495B615D297D66756E6374696F6E206728612C62297B666F722876617220633D612E6C656E6774682C643D5B5D3B63';
wwv_flow_api.g_varchar2_table(11) := '2D2D3B29645B635D3D6228615B635D293B72657475726E20647D66756E6374696F6E206828612C62297B76617220633D612E73706C697428224022292C643D22223B632E6C656E6774683E31262628643D635B305D2B2240222C613D635B315D292C613D';
wwv_flow_api.g_varchar2_table(12) := '612E7265706C61636528482C222E22293B76617220653D612E73706C697428222E22292C663D6728652C62292E6A6F696E28222E22293B72657475726E20642B667D66756E6374696F6E20692861297B666F722876617220622C632C643D5B5D2C653D30';
wwv_flow_api.g_varchar2_table(13) := '2C663D612E6C656E6774683B663E653B29623D612E63686172436F6465417428652B2B292C623E3D3535323936262635363331393E3D622626663E653F28633D612E63686172436F6465417428652B2B292C35363332303D3D2836343531322663293F64';
wwv_flow_api.g_varchar2_table(14) := '2E70757368282828313032332662293C3C3130292B28313032332663292B3635353336293A28642E707573682862292C652D2D29293A642E707573682862293B72657475726E20647D66756E6374696F6E206A2861297B72657475726E206728612C6675';
wwv_flow_api.g_varchar2_table(15) := '6E6374696F6E2861297B76617220623D22223B72657475726E20613E3635353335262628612D3D36353533362C622B3D4C28613E3E3E313026313032337C3535323936292C613D35363332307C313032332661292C622B3D4C2861297D292E6A6F696E28';
wwv_flow_api.g_varchar2_table(16) := '2222297D66756E6374696F6E206B2861297B72657475726E2031303E612D34383F612D32323A32363E612D36353F612D36353A32363E612D39373F612D39373A787D66756E6374696F6E206C28612C62297B72657475726E20612B32322B37352A283236';
wwv_flow_api.g_varchar2_table(17) := '3E61292D282830213D62293C3C35297D66756E6374696F6E206D28612C622C63297B76617220643D303B666F7228613D633F4B28612F42293A613E3E312C612B3D4B28612F62293B613E4A2A7A3E3E313B642B3D7829613D4B28612F4A293B7265747572';
wwv_flow_api.g_varchar2_table(18) := '6E204B28642B284A2B31292A612F28612B4129297D66756E6374696F6E206E2861297B76617220622C632C642C652C672C682C692C6C2C6E2C6F2C703D5B5D2C713D612E6C656E6774682C723D302C733D442C743D433B666F7228633D612E6C61737449';
wwv_flow_api.g_varchar2_table(19) := '6E6465784F662845292C303E63262628633D30292C643D303B633E643B2B2B6429612E63686172436F646541742864293E3D31323826266628226E6F742D626173696322292C702E7075736828612E63686172436F64654174286429293B666F7228653D';
wwv_flow_api.g_varchar2_table(20) := '633E303F632B313A303B713E653B297B666F7228673D722C683D312C693D783B653E3D712626662822696E76616C69642D696E70757422292C6C3D6B28612E63686172436F6465417428652B2B29292C286C3E3D787C7C6C3E4B2828772D72292F682929';
wwv_flow_api.g_varchar2_table(21) := '26266628226F766572666C6F7722292C722B3D6C2A682C6E3D743E3D693F793A693E3D742B7A3F7A3A692D742C21286E3E6C293B692B3D78296F3D782D6E2C683E4B28772F6F2926266628226F766572666C6F7722292C682A3D6F3B623D702E6C656E67';
wwv_flow_api.g_varchar2_table(22) := '74682B312C743D6D28722D672C622C303D3D67292C4B28722F62293E772D7326266628226F766572666C6F7722292C732B3D4B28722F62292C72253D622C702E73706C69636528722B2B2C302C73297D72657475726E206A2870297D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(23) := '206F2861297B76617220622C632C642C652C672C682C6A2C6B2C6E2C6F2C702C712C722C732C742C753D5B5D3B666F7228613D692861292C713D612E6C656E6774682C623D442C633D302C673D432C683D303B713E683B2B2B6829703D615B685D2C3132';
wwv_flow_api.g_varchar2_table(24) := '383E702626752E70757368284C287029293B666F7228643D653D752E6C656E6774682C652626752E707573682845293B713E643B297B666F72286A3D772C683D303B713E683B2B2B6829703D615B685D2C703E3D6226266A3E702626286A3D70293B666F';
wwv_flow_api.g_varchar2_table(25) := '7228723D642B312C6A2D623E4B2828772D63292F722926266628226F766572666C6F7722292C632B3D286A2D62292A722C623D6A2C683D303B713E683B2B2B6829696628703D615B685D2C623E7026262B2B633E7726266628226F766572666C6F772229';
wwv_flow_api.g_varchar2_table(26) := '2C703D3D62297B666F72286B3D632C6E3D783B6F3D673E3D6E3F793A6E3E3D672B7A3F7A3A6E2D672C21286F3E6B293B6E2B3D7829743D6B2D6F2C733D782D6F2C752E70757368284C286C286F2B7425732C302929292C6B3D4B28742F73293B752E7075';
wwv_flow_api.g_varchar2_table(27) := '7368284C286C286B2C302929292C673D6D28632C722C643D3D65292C633D302C2B2B647D2B2B632C2B2B627D72657475726E20752E6A6F696E282222297D66756E6374696F6E20702861297B72657475726E206828612C66756E6374696F6E2861297B72';
wwv_flow_api.g_varchar2_table(28) := '657475726E20462E746573742861293F6E28612E736C6963652834292E746F4C6F776572436173652829293A617D297D66756E6374696F6E20712861297B72657475726E206828612C66756E6374696F6E2861297B72657475726E20472E746573742861';
wwv_flow_api.g_varchar2_table(29) := '293F22786E2D2D222B6F2861293A617D297D76617220723D226F626A656374223D3D747970656F662064262664262621642E6E6F6465547970652626642C733D226F626A656374223D3D747970656F662063262663262621632E6E6F6465547970652626';
wwv_flow_api.g_varchar2_table(30) := '632C743D226F626A656374223D3D747970656F6620622626623B28742E676C6F62616C3D3D3D747C7C742E77696E646F773D3D3D747C7C742E73656C663D3D3D7429262628653D74293B76617220752C762C773D323134373438333634372C783D33362C';
wwv_flow_api.g_varchar2_table(31) := '793D312C7A3D32362C413D33382C423D3730302C433D37322C443D3132382C453D222D222C463D2F5E786E2D2D2F2C473D2F5B5E5C7832302D5C7837455D2F2C483D2F5B5C7832455C75333030325C75464630455C75464636315D2F672C493D7B6F7665';
wwv_flow_api.g_varchar2_table(32) := '72666C6F773A224F766572666C6F773A20696E707574206E6565647320776964657220696E74656765727320746F2070726F63657373222C226E6F742D6261736963223A22496C6C6567616C20696E707574203E3D203078383020286E6F742061206261';
wwv_flow_api.g_varchar2_table(33) := '73696320636F646520706F696E7429222C22696E76616C69642D696E707574223A22496E76616C696420696E707574227D2C4A3D782D792C4B3D4D6174682E666C6F6F722C4C3D537472696E672E66726F6D43686172436F64653B696628753D7B766572';
wwv_flow_api.g_varchar2_table(34) := '73696F6E3A22312E332E32222C756373323A7B6465636F64653A692C656E636F64653A6A7D2C6465636F64653A6E2C656E636F64653A6F2C746F41534349493A712C746F556E69636F64653A707D2C2266756E6374696F6E223D3D747970656F66206126';
wwv_flow_api.g_varchar2_table(35) := '26226F626A656374223D3D747970656F6620612E616D642626612E616D642961282270756E79636F6465222C66756E6374696F6E28297B72657475726E20757D293B656C7365206966287226267329696628632E6578706F7274733D3D7229732E657870';
wwv_flow_api.g_varchar2_table(36) := '6F7274733D753B656C736520666F72287620696E207529752E6861734F776E50726F7065727479287629262628725B765D3D755B765D293B656C736520652E70756E79636F64653D757D2874686973297D292E63616C6C28746869732C22756E64656669';
wwv_flow_api.g_varchar2_table(37) := '6E656422213D747970656F6620676C6F62616C3F676C6F62616C3A22756E646566696E656422213D747970656F662073656C663F73656C663A22756E646566696E656422213D747970656F662077696E646F773F77696E646F773A7B7D297D2C7B7D5D2C';
wwv_flow_api.g_varchar2_table(38) := '323A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C622C63297B21612E64656661756C74566965777C7C623D3D3D612E64656661756C74566965772E70616765584F66667365742626633D3D3D612E64656661756C74566965';
wwv_flow_api.g_varchar2_table(39) := '772E70616765594F66667365747C7C612E64656661756C74566965772E7363726F6C6C546F28622C63297D66756E6374696F6E206528612C62297B7472797B62262628622E77696474683D612E77696474682C622E6865696768743D612E686569676874';
wwv_flow_api.g_varchar2_table(40) := '2C622E676574436F6E746578742822326422292E707574496D6167654461746128612E676574436F6E746578742822326422292E676574496D6167654461746128302C302C612E77696474682C612E686569676874292C302C3029297D63617463682863';
wwv_flow_api.g_varchar2_table(41) := '297B682822556E61626C6520746F20636F70792063616E76617320636F6E74656E742066726F6D222C612C63297D7D66756E6374696F6E206628612C62297B666F722876617220633D333D3D3D612E6E6F6465547970653F646F63756D656E742E637265';
wwv_flow_api.g_varchar2_table(42) := '617465546578744E6F646528612E6E6F646556616C7565293A612E636C6F6E654E6F6465282131292C643D612E66697273744368696C643B643B2928623D3D3D21307C7C31213D3D642E6E6F6465547970657C7C2253435249505422213D3D642E6E6F64';
wwv_flow_api.g_varchar2_table(43) := '654E616D65292626632E617070656E644368696C64286628642C6229292C643D642E6E6578745369626C696E673B72657475726E20313D3D3D612E6E6F646554797065262628632E5F7363726F6C6C546F703D612E7363726F6C6C546F702C632E5F7363';
wwv_flow_api.g_varchar2_table(44) := '726F6C6C4C6566743D612E7363726F6C6C4C6566742C2243414E564153223D3D3D612E6E6F64654E616D653F6528612C63293A28225445585441524541223D3D3D612E6E6F64654E616D657C7C2253454C454354223D3D3D612E6E6F64654E616D652926';
wwv_flow_api.g_varchar2_table(45) := '2628632E76616C75653D612E76616C756529292C637D66756E6374696F6E20672861297B696628313D3D3D612E6E6F646554797065297B612E7363726F6C6C546F703D612E5F7363726F6C6C546F702C612E7363726F6C6C4C6566743D612E5F7363726F';
wwv_flow_api.g_varchar2_table(46) := '6C6C4C6566743B666F722876617220623D612E66697273744368696C643B623B29672862292C623D622E6E6578745369626C696E677D7D76617220683D6128222E2F6C6F6722293B622E6578706F7274733D66756E6374696F6E28612C622C632C652C68';
wwv_flow_api.g_varchar2_table(47) := '2C692C6A297B766172206B3D6628612E646F63756D656E74456C656D656E742C682E6A617661736372697074456E61626C6564292C6C3D622E637265617465456C656D656E742822696672616D6522293B72657475726E206C2E636C6173734E616D653D';
wwv_flow_api.g_varchar2_table(48) := '2268746D6C3263616E7661732D636F6E7461696E6572222C6C2E7374796C652E7669736962696C6974793D2268696464656E222C6C2E7374796C652E706F736974696F6E3D226669786564222C6C2E7374796C652E6C6566743D222D3130303030707822';
wwv_flow_api.g_varchar2_table(49) := '2C6C2E7374796C652E746F703D22307078222C6C2E7374796C652E626F726465723D2230222C6C2E77696474683D632C6C2E6865696768743D652C6C2E7363726F6C6C696E673D226E6F222C622E626F64792E617070656E644368696C64286C292C6E65';
wwv_flow_api.g_varchar2_table(50) := '772050726F6D6973652866756E6374696F6E2862297B76617220633D6C2E636F6E74656E7457696E646F772E646F63756D656E743B6C2E636F6E74656E7457696E646F772E6F6E6C6F61643D6C2E6F6E6C6F61643D66756E6374696F6E28297B76617220';
wwv_flow_api.g_varchar2_table(51) := '613D736574496E74657276616C2866756E6374696F6E28297B632E626F64792E6368696C644E6F6465732E6C656E6774683E302626286728632E646F63756D656E74456C656D656E74292C636C656172496E74657276616C2861292C2276696577223D3D';
wwv_flow_api.g_varchar2_table(52) := '3D682E747970652626286C2E636F6E74656E7457696E646F772E7363726F6C6C546F28692C6A292C212F28695061647C6950686F6E657C69506F64292F672E74657374286E6176696761746F722E757365724167656E74297C7C6C2E636F6E74656E7457';
wwv_flow_api.g_varchar2_table(53) := '696E646F772E7363726F6C6C593D3D3D6A26266C2E636F6E74656E7457696E646F772E7363726F6C6C583D3D3D697C7C28632E646F63756D656E74456C656D656E742E7374796C652E746F703D2D6A2B227078222C632E646F63756D656E74456C656D65';
wwv_flow_api.g_varchar2_table(54) := '6E742E7374796C652E6C6566743D2D692B227078222C632E646F63756D656E74456C656D656E742E7374796C652E706F736974696F6E3D226162736F6C7574652229292C62286C29297D2C3530297D2C632E6F70656E28292C632E777269746528223C21';
wwv_flow_api.g_varchar2_table(55) := '444F43545950452068746D6C3E3C68746D6C3E3C2F68746D6C3E22292C6428612C692C6A292C632E7265706C6163654368696C6428632E61646F70744E6F6465286B292C632E646F63756D656E74456C656D656E74292C632E636C6F736528297D297D7D';
wwv_flow_api.g_varchar2_table(56) := '2C7B222E2F6C6F67223A31337D5D2C333A5B66756E6374696F6E28612C622C63297B66756E6374696F6E20642861297B746869732E723D302C746869732E673D302C746869732E623D302C746869732E613D6E756C6C3B746869732E66726F6D41727261';
wwv_flow_api.g_varchar2_table(57) := '792861297C7C746869732E6E616D6564436F6C6F722861297C7C746869732E7267622861297C7C746869732E726762612861297C7C746869732E686578362861297C7C746869732E686578332861297D642E70726F746F747970652E6461726B656E3D66';
wwv_flow_api.g_varchar2_table(58) := '756E6374696F6E2861297B76617220623D312D613B72657475726E206E65772064285B4D6174682E726F756E6428746869732E722A62292C4D6174682E726F756E6428746869732E672A62292C4D6174682E726F756E6428746869732E622A62292C7468';
wwv_flow_api.g_varchar2_table(59) := '69732E615D297D2C642E70726F746F747970652E69735472616E73706172656E743D66756E6374696F6E28297B72657475726E20303D3D3D746869732E617D2C642E70726F746F747970652E6973426C61636B3D66756E6374696F6E28297B7265747572';
wwv_flow_api.g_varchar2_table(60) := '6E20303D3D3D746869732E722626303D3D3D746869732E672626303D3D3D746869732E627D2C642E70726F746F747970652E66726F6D41727261793D66756E6374696F6E2861297B72657475726E2041727261792E697341727261792861292626287468';
wwv_flow_api.g_varchar2_table(61) := '69732E723D4D6174682E6D696E28615B305D2C323535292C746869732E673D4D6174682E6D696E28615B315D2C323535292C746869732E623D4D6174682E6D696E28615B325D2C323535292C612E6C656E6774683E33262628746869732E613D615B335D';
wwv_flow_api.g_varchar2_table(62) := '29292C41727261792E697341727261792861297D3B76617220653D2F5E23285B612D66302D395D7B337D29242F693B642E70726F746F747970652E686578333D66756E6374696F6E2861297B76617220623D6E756C6C3B72657475726E206E756C6C213D';
wwv_flow_api.g_varchar2_table(63) := '3D28623D612E6D6174636828652929262628746869732E723D7061727365496E7428625B315D5B305D2B625B315D5B305D2C3136292C746869732E673D7061727365496E7428625B315D5B315D2B625B315D5B315D2C3136292C746869732E623D706172';
wwv_flow_api.g_varchar2_table(64) := '7365496E7428625B315D5B325D2B625B315D5B325D2C313629292C6E756C6C213D3D627D3B76617220663D2F5E23285B612D66302D395D7B367D29242F693B642E70726F746F747970652E686578363D66756E6374696F6E2861297B76617220623D6E75';
wwv_flow_api.g_varchar2_table(65) := '6C6C3B72657475726E206E756C6C213D3D28623D612E6D6174636828662929262628746869732E723D7061727365496E7428625B315D2E737562737472696E6728302C32292C3136292C746869732E673D7061727365496E7428625B315D2E7375627374';
wwv_flow_api.g_varchar2_table(66) := '72696E6728322C34292C3136292C746869732E623D7061727365496E7428625B315D2E737562737472696E6728342C36292C313629292C6E756C6C213D3D627D3B76617220673D2F5E7267625C285C732A285C647B312C337D295C732A2C5C732A285C64';
wwv_flow_api.g_varchar2_table(67) := '7B312C337D295C732A2C5C732A285C647B312C337D295C732A5C29242F3B642E70726F746F747970652E7267623D66756E6374696F6E2861297B76617220623D6E756C6C3B72657475726E206E756C6C213D3D28623D612E6D6174636828672929262628';
wwv_flow_api.g_varchar2_table(68) := '746869732E723D4E756D62657228625B315D292C746869732E673D4E756D62657228625B325D292C746869732E623D4E756D62657228625B335D29292C6E756C6C213D3D627D3B76617220683D2F5E726762615C285C732A285C647B312C337D295C732A';
wwv_flow_api.g_varchar2_table(69) := '2C5C732A285C647B312C337D295C732A2C5C732A285C647B312C337D295C732A2C5C732A285C643F5C2E3F5C642B295C732A5C29242F3B642E70726F746F747970652E726762613D66756E6374696F6E2861297B76617220623D6E756C6C3B7265747572';
wwv_flow_api.g_varchar2_table(70) := '6E206E756C6C213D3D28623D612E6D6174636828682929262628746869732E723D4E756D62657228625B315D292C746869732E673D4E756D62657228625B325D292C746869732E623D4E756D62657228625B335D292C746869732E613D4E756D62657228';
wwv_flow_api.g_varchar2_table(71) := '625B345D29292C6E756C6C213D3D627D2C642E70726F746F747970652E746F537472696E673D66756E6374696F6E28297B72657475726E206E756C6C213D3D746869732E61262631213D3D746869732E613F227267626128222B5B746869732E722C7468';
wwv_flow_api.g_varchar2_table(72) := '69732E672C746869732E622C746869732E615D2E6A6F696E28222C22292B2229223A2272676228222B5B746869732E722C746869732E672C746869732E625D2E6A6F696E28222C22292B2229227D2C642E70726F746F747970652E6E616D6564436F6C6F';
wwv_flow_api.g_varchar2_table(73) := '723D66756E6374696F6E2861297B613D612E746F4C6F7765724361736528293B76617220623D695B615D3B6966286229746869732E723D625B305D2C746869732E673D625B315D2C746869732E623D625B325D3B656C736520696628227472616E737061';
wwv_flow_api.g_varchar2_table(74) := '72656E74223D3D3D612972657475726E20746869732E723D746869732E673D746869732E623D746869732E613D302C21303B72657475726E2121627D2C642E70726F746F747970652E6973436F6C6F723D21303B76617220693D7B616C696365626C7565';
wwv_flow_api.g_varchar2_table(75) := '3A5B3234302C3234382C3235355D2C616E746971756577686974653A5B3235302C3233352C3231355D2C617175613A5B302C3235352C3235355D2C617175616D6172696E653A5B3132372C3235352C3231325D2C617A7572653A5B3234302C3235352C32';
wwv_flow_api.g_varchar2_table(76) := '35355D2C62656967653A5B3234352C3234352C3232305D2C6269737175653A5B3235352C3232382C3139365D2C626C61636B3A5B302C302C305D2C626C616E63686564616C6D6F6E643A5B3235352C3233352C3230355D2C626C75653A5B302C302C3235';
wwv_flow_api.g_varchar2_table(77) := '355D2C626C756576696F6C65743A5B3133382C34332C3232365D2C62726F776E3A5B3136352C34322C34325D2C6275726C79776F6F643A5B3232322C3138342C3133355D2C6361646574626C75653A5B39352C3135382C3136305D2C6368617274726575';
wwv_flow_api.g_varchar2_table(78) := '73653A5B3132372C3235352C305D2C63686F636F6C6174653A5B3231302C3130352C33305D2C636F72616C3A5B3235352C3132372C38305D2C636F726E666C6F776572626C75653A5B3130302C3134392C3233375D2C636F726E73696C6B3A5B3235352C';
wwv_flow_api.g_varchar2_table(79) := '3234382C3232305D2C6372696D736F6E3A5B3232302C32302C36305D2C6379616E3A5B302C3235352C3235355D2C6461726B626C75653A5B302C302C3133395D2C6461726B6379616E3A5B302C3133392C3133395D2C6461726B676F6C64656E726F643A';
wwv_flow_api.g_varchar2_table(80) := '5B3138342C3133342C31315D2C6461726B677261793A5B3136392C3136392C3136395D2C6461726B677265656E3A5B302C3130302C305D2C6461726B677265793A5B3136392C3136392C3136395D2C6461726B6B68616B693A5B3138392C3138332C3130';
wwv_flow_api.g_varchar2_table(81) := '375D2C6461726B6D6167656E74613A5B3133392C302C3133395D2C6461726B6F6C697665677265656E3A5B38352C3130372C34375D2C6461726B6F72616E67653A5B3235352C3134302C305D2C6461726B6F72636869643A5B3135332C35302C3230345D';
wwv_flow_api.g_varchar2_table(82) := '2C6461726B7265643A5B3133392C302C305D2C6461726B73616C6D6F6E3A5B3233332C3135302C3132325D2C6461726B736561677265656E3A5B3134332C3138382C3134335D2C6461726B736C617465626C75653A5B37322C36312C3133395D2C646172';
wwv_flow_api.g_varchar2_table(83) := '6B736C617465677261793A5B34372C37392C37395D2C6461726B736C617465677265793A5B34372C37392C37395D2C6461726B74757271756F6973653A5B302C3230362C3230395D2C6461726B76696F6C65743A5B3134382C302C3231315D2C64656570';
wwv_flow_api.g_varchar2_table(84) := '70696E6B3A5B3235352C32302C3134375D2C64656570736B79626C75653A5B302C3139312C3235355D2C64696D677261793A5B3130352C3130352C3130355D2C64696D677265793A5B3130352C3130352C3130355D2C646F64676572626C75653A5B3330';
wwv_flow_api.g_varchar2_table(85) := '2C3134342C3235355D2C66697265627269636B3A5B3137382C33342C33345D2C666C6F72616C77686974653A5B3235352C3235302C3234305D2C666F72657374677265656E3A5B33342C3133392C33345D2C667563687369613A5B3235352C302C323535';
wwv_flow_api.g_varchar2_table(86) := '5D2C6761696E73626F726F3A5B3232302C3232302C3232305D2C67686F737477686974653A5B3234382C3234382C3235355D2C676F6C643A5B3235352C3231352C305D2C676F6C64656E726F643A5B3231382C3136352C33325D2C677261793A5B313238';
wwv_flow_api.g_varchar2_table(87) := '2C3132382C3132385D2C677265656E3A5B302C3132382C305D2C677265656E79656C6C6F773A5B3137332C3235352C34375D2C677265793A5B3132382C3132382C3132385D2C686F6E65796465773A5B3234302C3235352C3234305D2C686F7470696E6B';
wwv_flow_api.g_varchar2_table(88) := '3A5B3235352C3130352C3138305D2C696E6469616E7265643A5B3230352C39322C39325D2C696E6469676F3A5B37352C302C3133305D2C69766F72793A5B3235352C3235352C3234305D2C6B68616B693A5B3234302C3233302C3134305D2C6C6176656E';
wwv_flow_api.g_varchar2_table(89) := '6465723A5B3233302C3233302C3235305D2C6C6176656E646572626C7573683A5B3235352C3234302C3234355D2C6C61776E677265656E3A5B3132342C3235322C305D2C6C656D6F6E63686966666F6E3A5B3235352C3235302C3230355D2C6C69676874';
wwv_flow_api.g_varchar2_table(90) := '626C75653A5B3137332C3231362C3233305D2C6C69676874636F72616C3A5B3234302C3132382C3132385D2C6C696768746379616E3A5B3232342C3235352C3235355D2C6C69676874676F6C64656E726F6479656C6C6F773A5B3235302C3235302C3231';
wwv_flow_api.g_varchar2_table(91) := '305D2C6C69676874677261793A5B3231312C3231312C3231315D2C6C69676874677265656E3A5B3134342C3233382C3134345D2C6C69676874677265793A5B3231312C3231312C3231315D2C6C6967687470696E6B3A5B3235352C3138322C3139335D2C';
wwv_flow_api.g_varchar2_table(92) := '6C6967687473616C6D6F6E3A5B3235352C3136302C3132325D2C6C69676874736561677265656E3A5B33322C3137382C3137305D2C6C69676874736B79626C75653A5B3133352C3230362C3235305D2C6C69676874736C617465677261793A5B3131392C';
wwv_flow_api.g_varchar2_table(93) := '3133362C3135335D2C6C69676874736C617465677265793A5B3131392C3133362C3135335D2C6C69676874737465656C626C75653A5B3137362C3139362C3232325D2C6C6967687479656C6C6F773A5B3235352C3235352C3232345D2C6C696D653A5B30';
wwv_flow_api.g_varchar2_table(94) := '2C3235352C305D2C6C696D65677265656E3A5B35302C3230352C35305D2C6C696E656E3A5B3235302C3234302C3233305D2C6D6167656E74613A5B3235352C302C3235355D2C6D61726F6F6E3A5B3132382C302C305D2C6D656469756D617175616D6172';
wwv_flow_api.g_varchar2_table(95) := '696E653A5B3130322C3230352C3137305D2C6D656469756D626C75653A5B302C302C3230355D2C6D656469756D6F72636869643A5B3138362C38352C3231315D2C6D656469756D707572706C653A5B3134372C3131322C3231395D2C6D656469756D7365';
wwv_flow_api.g_varchar2_table(96) := '61677265656E3A5B36302C3137392C3131335D2C6D656469756D736C617465626C75653A5B3132332C3130342C3233385D2C6D656469756D737072696E67677265656E3A5B302C3235302C3135345D2C6D656469756D74757271756F6973653A5B37322C';
wwv_flow_api.g_varchar2_table(97) := '3230392C3230345D2C6D656469756D76696F6C65747265643A5B3139392C32312C3133335D2C6D69646E69676874626C75653A5B32352C32352C3131325D2C6D696E74637265616D3A5B3234352C3235352C3235305D2C6D69737479726F73653A5B3235';
wwv_flow_api.g_varchar2_table(98) := '352C3232382C3232355D2C6D6F63636173696E3A5B3235352C3232382C3138315D2C6E6176616A6F77686974653A5B3235352C3232322C3137335D2C6E6176793A5B302C302C3132385D2C6F6C646C6163653A5B3235332C3234352C3233305D2C6F6C69';
wwv_flow_api.g_varchar2_table(99) := '76653A5B3132382C3132382C305D2C6F6C697665647261623A5B3130372C3134322C33355D2C6F72616E67653A5B3235352C3136352C305D2C6F72616E67657265643A5B3235352C36392C305D2C6F72636869643A5B3231382C3131322C3231345D2C70';
wwv_flow_api.g_varchar2_table(100) := '616C65676F6C64656E726F643A5B3233382C3233322C3137305D2C70616C65677265656E3A5B3135322C3235312C3135325D2C70616C6574757271756F6973653A5B3137352C3233382C3233385D2C70616C6576696F6C65747265643A5B3231392C3131';
wwv_flow_api.g_varchar2_table(101) := '322C3134375D2C706170617961776869703A5B3235352C3233392C3231335D2C7065616368707566663A5B3235352C3231382C3138355D2C706572753A5B3230352C3133332C36335D2C70696E6B3A5B3235352C3139322C3230335D2C706C756D3A5B32';
wwv_flow_api.g_varchar2_table(102) := '32312C3136302C3232315D2C706F77646572626C75653A5B3137362C3232342C3233305D2C707572706C653A5B3132382C302C3132385D2C72656265636361707572706C653A5B3130322C35312C3135335D2C7265643A5B3235352C302C305D2C726F73';
wwv_flow_api.g_varchar2_table(103) := '7962726F776E3A5B3138382C3134332C3134335D2C726F79616C626C75653A5B36352C3130352C3232355D2C736164646C6562726F776E3A5B3133392C36392C31395D2C73616C6D6F6E3A5B3235302C3132382C3131345D2C73616E647962726F776E3A';
wwv_flow_api.g_varchar2_table(104) := '5B3234342C3136342C39365D2C736561677265656E3A5B34362C3133392C38375D2C7365617368656C6C3A5B3235352C3234352C3233385D2C7369656E6E613A5B3136302C38322C34355D2C73696C7665723A5B3139322C3139322C3139325D2C736B79';
wwv_flow_api.g_varchar2_table(105) := '626C75653A5B3133352C3230362C3233355D2C736C617465626C75653A5B3130362C39302C3230355D2C736C617465677261793A5B3131322C3132382C3134345D2C736C617465677265793A5B3131322C3132382C3134345D2C736E6F773A5B3235352C';
wwv_flow_api.g_varchar2_table(106) := '3235302C3235305D2C737072696E67677265656E3A5B302C3235352C3132375D2C737465656C626C75653A5B37302C3133302C3138305D2C74616E3A5B3231302C3138302C3134305D2C7465616C3A5B302C3132382C3132385D2C74686973746C653A5B';
wwv_flow_api.g_varchar2_table(107) := '3231362C3139312C3231365D2C746F6D61746F3A5B3235352C39392C37315D2C74757271756F6973653A5B36342C3232342C3230385D2C76696F6C65743A5B3233382C3133302C3233385D2C77686561743A5B3234352C3232322C3137395D2C77686974';
wwv_flow_api.g_varchar2_table(108) := '653A5B3235352C3235352C3235355D2C7768697465736D6F6B653A5B3234352C3234352C3234355D2C79656C6C6F773A5B3235352C3235352C305D2C79656C6C6F77677265656E3A5B3135342C3230352C35305D7D3B622E6578706F7274733D647D2C7B';
wwv_flow_api.g_varchar2_table(109) := '7D5D2C343A5B66756E6374696F6E28622C632C64297B66756E6374696F6E206528612C62297B76617220633D782B2B3B696628623D627C7C7B7D2C622E6C6F6767696E6726262877696E646F772E68746D6C3263616E7661732E6C6F6767696E673D2130';
wwv_flow_api.g_varchar2_table(110) := '2C77696E646F772E68746D6C3263616E7661732E73746172743D446174652E6E6F772829292C622E6173796E633D22756E646566696E6564223D3D747970656F6620622E6173796E633F21303A622E6173796E632C622E616C6C6F775461696E743D2275';
wwv_flow_api.g_varchar2_table(111) := '6E646566696E6564223D3D747970656F6620622E616C6C6F775461696E743F21313A622E616C6C6F775461696E742C622E72656D6F7665436F6E7461696E65723D22756E646566696E6564223D3D747970656F6620622E72656D6F7665436F6E7461696E';
wwv_flow_api.g_varchar2_table(112) := '65723F21303A622E72656D6F7665436F6E7461696E65722C622E6A617661736372697074456E61626C65643D22756E646566696E6564223D3D747970656F6620622E6A617661736372697074456E61626C65643F21313A622E6A61766173637269707445';
wwv_flow_api.g_varchar2_table(113) := '6E61626C65642C622E696D61676554696D656F75743D22756E646566696E6564223D3D747970656F6620622E696D61676554696D656F75743F3165343A622E696D61676554696D656F75742C622E72656E64657265723D2266756E6374696F6E223D3D74';
wwv_flow_api.g_varchar2_table(114) := '7970656F6620622E72656E64657265723F622E72656E64657265723A6E2C622E7374726963743D2121622E7374726963742C22737472696E67223D3D747970656F662061297B69662822737472696E6722213D747970656F6620622E70726F7879297265';
wwv_flow_api.g_varchar2_table(115) := '7475726E2050726F6D6973652E72656A656374282250726F7879206D7573742062652075736564207768656E2072656E646572696E672075726C22293B76617220643D6E756C6C213D622E77696474683F622E77696474683A77696E646F772E696E6E65';
wwv_flow_api.g_varchar2_table(116) := '7257696474682C653D6E756C6C213D622E6865696768743F622E6865696768743A77696E646F772E696E6E65724865696768743B72657475726E2075286C2861292C622E70726F78792C646F63756D656E742C642C652C62292E7468656E2866756E6374';
wwv_flow_api.g_varchar2_table(117) := '696F6E2861297B72657475726E206728612E636F6E74656E7457696E646F772E646F63756D656E742E646F63756D656E74456C656D656E742C612C622C642C65297D297D76617220683D28766F696420303D3D3D613F5B646F63756D656E742E646F6375';
wwv_flow_api.g_varchar2_table(118) := '6D656E74456C656D656E745D3A612E6C656E6774683F613A5B615D295B305D3B72657475726E20682E73657441747472696275746528772B632C63292C6628682E6F776E6572446F63756D656E742C622C682E6F776E6572446F63756D656E742E646566';
wwv_flow_api.g_varchar2_table(119) := '61756C74566965772E696E6E657257696474682C682E6F776E6572446F63756D656E742E64656661756C74566965772E696E6E65724865696768742C63292E7468656E2866756E6374696F6E2861297B72657475726E2266756E6374696F6E223D3D7479';
wwv_flow_api.g_varchar2_table(120) := '70656F6620622E6F6E72656E64657265642626287228226F7074696F6E732E6F6E72656E646572656420697320646570726563617465642C2068746D6C3263616E7661732072657475726E7320612050726F6D69736520636F6E7461696E696E67207468';
wwv_flow_api.g_varchar2_table(121) := '652063616E76617322292C622E6F6E72656E6465726564286129292C617D297D66756E6374696F6E206628612C622C632C642C65297B72657475726E207428612C612C632C642C622C612E64656661756C74566965772E70616765584F66667365742C61';
wwv_flow_api.g_varchar2_table(122) := '2E64656661756C74566965772E70616765594F6666736574292E7468656E2866756E6374696F6E2866297B722822446F63756D656E7420636C6F6E656422293B76617220683D772B652C693D225B222B682B223D27222B652B22275D223B612E71756572';
wwv_flow_api.g_varchar2_table(123) := '7953656C6563746F722869292E72656D6F76654174747269627574652868293B766172206A3D662E636F6E74656E7457696E646F772C6B3D6A2E646F63756D656E742E717565727953656C6563746F722869292C6C3D2266756E6374696F6E223D3D7479';
wwv_flow_api.g_varchar2_table(124) := '70656F6620622E6F6E636C6F6E653F50726F6D6973652E7265736F6C766528622E6F6E636C6F6E65286A2E646F63756D656E7429293A50726F6D6973652E7265736F6C7665282130293B72657475726E206C2E7468656E2866756E6374696F6E28297B72';
wwv_flow_api.g_varchar2_table(125) := '657475726E2067286B2C662C622C632C64297D297D297D66756E6374696F6E206728612C622C632C642C65297B76617220663D622E636F6E74656E7457696E646F772C673D6E6577206D28662E646F63756D656E74292C6C3D6E6577206F28632C67292C';
wwv_flow_api.g_varchar2_table(126) := '6E3D762861292C713D2276696577223D3D3D632E747970653F643A6A28662E646F63756D656E74292C733D2276696577223D3D3D632E747970653F653A6B28662E646F63756D656E74292C743D6E657720632E72656E646572657228712C732C6C2C632C';
wwv_flow_api.g_varchar2_table(127) := '646F63756D656E74292C753D6E6577207028612C742C672C6C2C63293B72657475726E20752E72656164792E7468656E2866756E6374696F6E28297B72282246696E69736865642072656E646572696E6722293B76617220643B72657475726E20643D22';
wwv_flow_api.g_varchar2_table(128) := '76696577223D3D3D632E747970653F6928742E63616E7661732C7B77696474683A742E63616E7661732E77696474682C6865696768743A742E63616E7661732E6865696768742C746F703A302C6C6566743A302C783A302C793A307D293A613D3D3D662E';
wwv_flow_api.g_varchar2_table(129) := '646F63756D656E742E626F64797C7C613D3D3D662E646F63756D656E742E646F63756D656E74456C656D656E747C7C6E756C6C213D632E63616E7661733F742E63616E7661733A6928742E63616E7661732C7B77696474683A6E756C6C213D632E776964';
wwv_flow_api.g_varchar2_table(130) := '74683F632E77696474683A6E2E77696474682C6865696768743A6E756C6C213D632E6865696768743F632E6865696768743A6E2E6865696768742C746F703A6E2E746F702C6C6566743A6E2E6C6566742C783A662E70616765584F66667365742C793A66';
wwv_flow_api.g_varchar2_table(131) := '2E70616765594F66667365747D292C6828622C63292C647D297D66756E6374696F6E206828612C62297B622E72656D6F7665436F6E7461696E6572262628612E706172656E744E6F64652E72656D6F76654368696C642861292C722822436C65616E6564';
wwv_flow_api.g_varchar2_table(132) := '20757020636F6E7461696E65722229297D66756E6374696F6E206928612C62297B76617220633D646F63756D656E742E637265617465456C656D656E74282263616E76617322292C643D4D6174682E6D696E28612E77696474682D312C4D6174682E6D61';
wwv_flow_api.g_varchar2_table(133) := '7828302C622E6C65667429292C653D4D6174682E6D696E28612E77696474682C4D6174682E6D617828312C622E6C6566742B622E776964746829292C663D4D6174682E6D696E28612E6865696768742D312C4D6174682E6D617828302C622E746F702929';
wwv_flow_api.g_varchar2_table(134) := '2C673D4D6174682E6D696E28612E6865696768742C4D6174682E6D617828312C622E746F702B622E68656967687429293B72657475726E20632E77696474683D622E77696474682C632E6865696768743D622E6865696768742C72282243726F7070696E';
wwv_flow_api.g_varchar2_table(135) := '672063616E7661732061743A222C226C6566743A222C622E6C6566742C22746F703A222C622E746F702C2277696474683A222C652D642C226865696768743A222C672D66292C722822526573756C74696E672063726F702077697468207769647468222C';
wwv_flow_api.g_varchar2_table(136) := '622E77696474682C22616E6420686569676874222C622E6865696768742C2220776974682078222C642C22616E642079222C66292C632E676574436F6E746578742822326422292E64726177496D61676528612C642C662C652D642C672D662C622E782C';
wwv_flow_api.g_varchar2_table(137) := '622E792C652D642C672D66292C637D66756E6374696F6E206A2861297B72657475726E204D6174682E6D6178284D6174682E6D617828612E626F64792E7363726F6C6C57696474682C612E646F63756D656E74456C656D656E742E7363726F6C6C576964';
wwv_flow_api.g_varchar2_table(138) := '7468292C4D6174682E6D617828612E626F64792E6F666673657457696474682C612E646F63756D656E74456C656D656E742E6F66667365745769647468292C4D6174682E6D617828612E626F64792E636C69656E7457696474682C612E646F63756D656E';
wwv_flow_api.g_varchar2_table(139) := '74456C656D656E742E636C69656E74576964746829297D66756E6374696F6E206B2861297B72657475726E204D6174682E6D6178284D6174682E6D617828612E626F64792E7363726F6C6C4865696768742C612E646F63756D656E74456C656D656E742E';
wwv_flow_api.g_varchar2_table(140) := '7363726F6C6C486569676874292C4D6174682E6D617828612E626F64792E6F66667365744865696768742C612E646F63756D656E74456C656D656E742E6F6666736574486569676874292C4D6174682E6D617828612E626F64792E636C69656E74486569';
wwv_flow_api.g_varchar2_table(141) := '6768742C612E646F63756D656E74456C656D656E742E636C69656E7448656967687429297D66756E6374696F6E206C2861297B76617220623D646F63756D656E742E637265617465456C656D656E7428226122293B72657475726E20622E687265663D61';
wwv_flow_api.g_varchar2_table(142) := '2C622E687265663D622E687265662C627D766172206D3D6228222E2F737570706F727422292C6E3D6228222E2F72656E6465726572732F63616E76617322292C6F3D6228222E2F696D6167656C6F6164657222292C703D6228222E2F6E6F646570617273';
wwv_flow_api.g_varchar2_table(143) := '657222292C713D6228222E2F6E6F6465636F6E7461696E657222292C723D6228222E2F6C6F6722292C733D6228222E2F7574696C7322292C743D6228222E2F636C6F6E6522292C753D6228222E2F70726F787922292E6C6F616455726C446F63756D656E';
wwv_flow_api.g_varchar2_table(144) := '742C763D732E676574426F756E64732C773D22646174612D68746D6C3263616E7661732D6E6F6465222C783D303B652E43616E76617352656E64657265723D6E2C652E4E6F6465436F6E7461696E65723D712C652E6C6F673D722C652E7574696C733D73';
wwv_flow_api.g_varchar2_table(145) := '3B76617220793D22756E646566696E6564223D3D747970656F6620646F63756D656E747C7C2266756E6374696F6E22213D747970656F66204F626A6563742E6372656174657C7C2266756E6374696F6E22213D747970656F6620646F63756D656E742E63';
wwv_flow_api.g_varchar2_table(146) := '7265617465456C656D656E74282263616E76617322292E676574436F6E746578743F66756E6374696F6E28297B72657475726E2050726F6D6973652E72656A65637428224E6F2063616E76617320737570706F727422297D3A653B632E6578706F727473';
wwv_flow_api.g_varchar2_table(147) := '3D792C2266756E6374696F6E223D3D747970656F6620612626612E616D64262661282268746D6C3263616E766173222C5B5D2C66756E6374696F6E28297B72657475726E20797D297D2C7B222E2F636C6F6E65223A322C222E2F696D6167656C6F616465';
wwv_flow_api.g_varchar2_table(148) := '72223A31312C222E2F6C6F67223A31332C222E2F6E6F6465636F6E7461696E6572223A31342C222E2F6E6F6465706172736572223A31352C222E2F70726F7879223A31362C222E2F72656E6465726572732F63616E766173223A32302C222E2F73757070';
wwv_flow_api.g_varchar2_table(149) := '6F7274223A32322C222E2F7574696C73223A32367D5D2C353A5B66756E6374696F6E28612C622C63297B66756E6374696F6E20642861297B696628746869732E7372633D612C65282244756D6D79496D616765436F6E7461696E657220666F72222C6129';
wwv_flow_api.g_varchar2_table(150) := '2C21746869732E70726F6D6973657C7C21746869732E696D616765297B652822496E6974696174696E672044756D6D79496D616765436F6E7461696E657222292C642E70726F746F747970652E696D6167653D6E657720496D6167653B76617220623D74';
wwv_flow_api.g_varchar2_table(151) := '6869732E696D6167653B642E70726F746F747970652E70726F6D6973653D6E65772050726F6D6973652866756E6374696F6E28612C63297B622E6F6E6C6F61643D612C622E6F6E6572726F723D632C622E7372633D6628292C622E636F6D706C6574653D';
wwv_flow_api.g_varchar2_table(152) := '3D3D21302626612862297D297D7D76617220653D6128222E2F6C6F6722292C663D6128222E2F7574696C7322292E736D616C6C496D6167653B622E6578706F7274733D647D2C7B222E2F6C6F67223A31332C222E2F7574696C73223A32367D5D2C363A5B';
wwv_flow_api.g_varchar2_table(153) := '66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B76617220632C642C663D646F63756D656E742E637265617465456C656D656E74282264697622292C673D646F63756D656E742E637265617465456C656D656E742822696D';
wwv_flow_api.g_varchar2_table(154) := '6722292C683D646F63756D656E742E637265617465456C656D656E7428227370616E22292C693D2248696464656E2054657874223B662E7374796C652E7669736962696C6974793D2268696464656E222C662E7374796C652E666F6E7446616D696C793D';
wwv_flow_api.g_varchar2_table(155) := '612C662E7374796C652E666F6E7453697A653D622C662E7374796C652E6D617267696E3D302C662E7374796C652E70616464696E673D302C646F63756D656E742E626F64792E617070656E644368696C642866292C672E7372633D6528292C672E776964';
wwv_flow_api.g_varchar2_table(156) := '74683D312C672E6865696768743D312C672E7374796C652E6D617267696E3D302C672E7374796C652E70616464696E673D302C672E7374796C652E766572746963616C416C69676E3D22626173656C696E65222C682E7374796C652E666F6E7446616D69';
wwv_flow_api.g_varchar2_table(157) := '6C793D612C682E7374796C652E666F6E7453697A653D622C682E7374796C652E6D617267696E3D302C682E7374796C652E70616464696E673D302C682E617070656E644368696C6428646F63756D656E742E637265617465546578744E6F646528692929';
wwv_flow_api.g_varchar2_table(158) := '2C662E617070656E644368696C642868292C662E617070656E644368696C642867292C633D672E6F6666736574546F702D682E6F6666736574546F702B312C662E72656D6F76654368696C642868292C662E617070656E644368696C6428646F63756D65';
wwv_flow_api.g_varchar2_table(159) := '6E742E637265617465546578744E6F6465286929292C662E7374796C652E6C696E654865696768743D226E6F726D616C222C672E7374796C652E766572746963616C416C69676E3D227375706572222C643D672E6F6666736574546F702D662E6F666673';
wwv_flow_api.g_varchar2_table(160) := '6574546F702B312C646F63756D656E742E626F64792E72656D6F76654368696C642866292C746869732E626173656C696E653D632C746869732E6C696E6557696474683D312C746869732E6D6964646C653D647D76617220653D6128222E2F7574696C73';
wwv_flow_api.g_varchar2_table(161) := '22292E736D616C6C496D6167653B622E6578706F7274733D647D2C7B222E2F7574696C73223A32367D5D2C373A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428297B746869732E646174613D7B7D7D76617220653D6128222E2F66';
wwv_flow_api.g_varchar2_table(162) := '6F6E7422293B642E70726F746F747970652E6765744D6574726963733D66756E6374696F6E28612C62297B72657475726E20766F696420303D3D3D746869732E646174615B612B222D222B625D262628746869732E646174615B612B222D222B625D3D6E';
wwv_flow_api.g_varchar2_table(163) := '6577206528612C6229292C746869732E646174615B612B222D222B625D7D2C622E6578706F7274733D647D2C7B222E2F666F6E74223A367D5D2C383A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428622C632C64297B746869732E';
wwv_flow_api.g_varchar2_table(164) := '696D6167653D6E756C6C2C746869732E7372633D623B76617220653D746869732C673D662862293B746869732E70726F6D6973653D28633F6E65772050726F6D6973652866756E6374696F6E2861297B2261626F75743A626C616E6B223D3D3D622E636F';
wwv_flow_api.g_varchar2_table(165) := '6E74656E7457696E646F772E646F63756D656E742E55524C7C7C6E756C6C3D3D622E636F6E74656E7457696E646F772E646F63756D656E742E646F63756D656E74456C656D656E743F622E636F6E74656E7457696E646F772E6F6E6C6F61643D622E6F6E';
wwv_flow_api.g_varchar2_table(166) := '6C6F61643D66756E6374696F6E28297B612862297D3A612862297D293A746869732E70726F78794C6F616428642E70726F78792C672C6429292E7468656E2866756E6374696F6E2862297B76617220633D6128222E2F636F726522293B72657475726E20';
wwv_flow_api.g_varchar2_table(167) := '6328622E636F6E74656E7457696E646F772E646F63756D656E742E646F63756D656E74456C656D656E742C7B747970653A2276696577222C77696474683A622E77696474682C6865696768743A622E6865696768742C70726F78793A642E70726F78792C';
wwv_flow_api.g_varchar2_table(168) := '6A617661736372697074456E61626C65643A642E6A617661736372697074456E61626C65642C72656D6F7665436F6E7461696E65723A642E72656D6F7665436F6E7461696E65722C616C6C6F775461696E743A642E616C6C6F775461696E742C696D6167';
wwv_flow_api.g_varchar2_table(169) := '6554696D656F75743A642E696D61676554696D656F75742F327D297D292E7468656E2866756E6374696F6E2861297B72657475726E20652E696D6167653D617D297D76617220653D6128222E2F7574696C7322292C663D652E676574426F756E64732C67';
wwv_flow_api.g_varchar2_table(170) := '3D6128222E2F70726F787922292E6C6F616455726C446F63756D656E743B642E70726F746F747970652E70726F78794C6F61643D66756E6374696F6E28612C622C63297B76617220643D746869732E7372633B72657475726E206728642E7372632C612C';
wwv_flow_api.g_varchar2_table(171) := '642E6F776E6572446F63756D656E742C622E77696474682C622E6865696768742C63297D2C622E6578706F7274733D647D2C7B222E2F636F7265223A342C222E2F70726F7879223A31362C222E2F7574696C73223A32367D5D2C393A5B66756E6374696F';
wwv_flow_api.g_varchar2_table(172) := '6E28612C622C63297B66756E6374696F6E20642861297B746869732E7372633D612E76616C75652C746869732E636F6C6F7253746F70733D5B5D2C746869732E747970653D6E756C6C2C746869732E78303D2E352C746869732E79303D2E352C74686973';
wwv_flow_api.g_varchar2_table(173) := '2E78313D2E352C746869732E79313D2E352C746869732E70726F6D6973653D50726F6D6973652E7265736F6C7665282130297D642E54595045533D7B4C494E4541523A312C52414449414C3A327D2C642E5245474558505F434F4C4F5253544F503D2F5E';
wwv_flow_api.g_varchar2_table(174) := '5C732A28726762613F5C285C732A5C647B312C337D2C5C732A5C647B312C337D2C5C732A5C647B312C337D283F3A2C5C732A5B302D395C2E5D2B293F5C732A5C297C5B612D7A5D7B332C32307D7C235B612D66302D395D7B332C367D29283F3A5C732B28';
wwv_flow_api.g_varchar2_table(175) := '5C647B312C337D283F3A5C2E5C642B293F2928257C7078293F293F283F3A5C737C24292F692C622E6578706F7274733D647D2C7B7D5D2C31303A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B746869732E7372633D';
wwv_flow_api.g_varchar2_table(176) := '612C746869732E696D6167653D6E657720496D6167653B76617220633D746869733B746869732E7461696E7465643D6E756C6C2C746869732E70726F6D6973653D6E65772050726F6D6973652866756E6374696F6E28642C65297B632E696D6167652E6F';
wwv_flow_api.g_varchar2_table(177) := '6E6C6F61643D642C632E696D6167652E6F6E6572726F723D652C62262628632E696D6167652E63726F73734F726967696E3D22616E6F6E796D6F757322292C632E696D6167652E7372633D612C632E696D6167652E636F6D706C6574653D3D3D21302626';
wwv_flow_api.g_varchar2_table(178) := '6428632E696D616765297D297D622E6578706F7274733D647D2C7B7D5D2C31313A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B746869732E6C696E6B3D6E756C6C2C746869732E6F7074696F6E733D612C74686973';
wwv_flow_api.g_varchar2_table(179) := '2E737570706F72743D622C746869732E6F726967696E3D746869732E6765744F726967696E2877696E646F772E6C6F636174696F6E2E68726566297D76617220653D6128222E2F6C6F6722292C663D6128222E2F696D616765636F6E7461696E65722229';
wwv_flow_api.g_varchar2_table(180) := '2C673D6128222E2F64756D6D79696D616765636F6E7461696E657222292C683D6128222E2F70726F7879696D616765636F6E7461696E657222292C693D6128222E2F6672616D65636F6E7461696E657222292C6A3D6128222E2F737667636F6E7461696E';
wwv_flow_api.g_varchar2_table(181) := '657222292C6B3D6128222E2F7376676E6F6465636F6E7461696E657222292C6C3D6128222E2F6C696E6561726772616469656E74636F6E7461696E657222292C6D3D6128222E2F7765626B69746772616469656E74636F6E7461696E657222292C6E3D61';
wwv_flow_api.g_varchar2_table(182) := '28222E2F7574696C7322292E62696E643B642E70726F746F747970652E66696E64496D616765733D66756E6374696F6E2861297B76617220623D5B5D3B72657475726E20612E7265647563652866756E6374696F6E28612C62297B73776974636828622E';
wwv_flow_api.g_varchar2_table(183) := '6E6F64652E6E6F64654E616D65297B6361736522494D47223A72657475726E20612E636F6E636174285B7B617267733A5B622E6E6F64652E7372635D2C6D6574686F643A2275726C227D5D293B6361736522737667223A6361736522494652414D45223A';
wwv_flow_api.g_varchar2_table(184) := '72657475726E20612E636F6E636174285B7B617267733A5B622E6E6F64655D2C6D6574686F643A622E6E6F64652E6E6F64654E616D657D5D297D72657475726E20617D2C5B5D292E666F724561636828746869732E616464496D61676528622C74686973';
wwv_flow_api.g_varchar2_table(185) := '2E6C6F6164496D616765292C74686973292C627D2C642E70726F746F747970652E66696E644261636B67726F756E64496D6167653D66756E6374696F6E28612C62297B72657475726E20622E70617273654261636B67726F756E64496D6167657328292E';
wwv_flow_api.g_varchar2_table(186) := '66696C74657228746869732E686173496D6167654261636B67726F756E64292E666F724561636828746869732E616464496D61676528612C746869732E6C6F6164496D616765292C74686973292C617D2C642E70726F746F747970652E616464496D6167';
wwv_flow_api.g_varchar2_table(187) := '653D66756E6374696F6E28612C62297B72657475726E2066756E6374696F6E2863297B632E617267732E666F72456163682866756E6374696F6E2864297B746869732E696D61676545786973747328612C64297C7C28612E73706C69636528302C302C62';
wwv_flow_api.g_varchar2_table(188) := '2E63616C6C28746869732C6329292C652822416464656420696D6167652023222B612E6C656E6774682C22737472696E67223D3D747970656F6620643F642E737562737472696E6728302C313030293A6429297D2C74686973297D7D2C642E70726F746F';
wwv_flow_api.g_varchar2_table(189) := '747970652E686173496D6167654261636B67726F756E643D66756E6374696F6E2861297B72657475726E226E6F6E6522213D3D612E6D6574686F647D2C642E70726F746F747970652E6C6F6164496D6167653D66756E6374696F6E2861297B6966282275';
wwv_flow_api.g_varchar2_table(190) := '726C223D3D3D612E6D6574686F64297B76617220623D612E617267735B305D3B72657475726E21746869732E69735356472862297C7C746869732E737570706F72742E7376677C7C746869732E6F7074696F6E732E616C6C6F775461696E743F622E6D61';
wwv_flow_api.g_varchar2_table(191) := '746368282F646174613A696D6167655C2F2E2A3B6261736536342C2F69293F6E6577206628622E7265706C616365282F75726C5C285B27225D7B302C7D7C5B27225D7B302C7D5C29242F67692C2222292C2131293A746869732E697353616D654F726967';
wwv_flow_api.g_varchar2_table(192) := '696E2862297C7C746869732E6F7074696F6E732E616C6C6F775461696E743D3D3D21307C7C746869732E69735356472862293F6E6577206628622C2131293A746869732E737570706F72742E636F7273262621746869732E6F7074696F6E732E616C6C6F';
wwv_flow_api.g_varchar2_table(193) := '775461696E742626746869732E6F7074696F6E732E757365434F52533F6E6577206628622C2130293A746869732E6F7074696F6E732E70726F78793F6E6577206828622C746869732E6F7074696F6E732E70726F7879293A6E657720672862293A6E6577';
wwv_flow_api.g_varchar2_table(194) := '206A2862297D72657475726E226C696E6561722D6772616469656E74223D3D3D612E6D6574686F643F6E6577206C2861293A226772616469656E74223D3D3D612E6D6574686F643F6E6577206D2861293A22737667223D3D3D612E6D6574686F643F6E65';
wwv_flow_api.g_varchar2_table(195) := '77206B28612E617267735B305D2C746869732E737570706F72742E737667293A22494652414D45223D3D3D612E6D6574686F643F6E6577206928612E617267735B305D2C746869732E697353616D654F726967696E28612E617267735B305D2E73726329';
wwv_flow_api.g_varchar2_table(196) := '2C746869732E6F7074696F6E73293A6E657720672861297D2C642E70726F746F747970652E69735356473D66756E6374696F6E2861297B72657475726E22737667223D3D3D612E737562737472696E6728612E6C656E6774682D33292E746F4C6F776572';
wwv_flow_api.g_varchar2_table(197) := '4361736528297C7C6A2E70726F746F747970652E6973496E6C696E652861297D2C642E70726F746F747970652E696D6167654578697374733D66756E6374696F6E28612C62297B72657475726E20612E736F6D652866756E6374696F6E2861297B726574';
wwv_flow_api.g_varchar2_table(198) := '75726E20612E7372633D3D3D627D297D2C642E70726F746F747970652E697353616D654F726967696E3D66756E6374696F6E2861297B72657475726E20746869732E6765744F726967696E2861293D3D3D746869732E6F726967696E7D2C642E70726F74';
wwv_flow_api.g_varchar2_table(199) := '6F747970652E6765744F726967696E3D66756E6374696F6E2861297B76617220623D746869732E6C696E6B7C7C28746869732E6C696E6B3D646F63756D656E742E637265617465456C656D656E742822612229293B72657475726E20622E687265663D61';
wwv_flow_api.g_varchar2_table(200) := '2C622E687265663D622E687265662C622E70726F746F636F6C2B622E686F73746E616D652B622E706F72747D2C642E70726F746F747970652E67657450726F6D6973653D66756E6374696F6E2861297B72657475726E20746869732E74696D656F757428';
wwv_flow_api.g_varchar2_table(201) := '612C746869732E6F7074696F6E732E696D61676554696D656F7574295B226361746368225D2866756E6374696F6E28297B76617220623D6E6577206728612E737263293B72657475726E20622E70726F6D6973652E7468656E2866756E6374696F6E2862';
wwv_flow_api.g_varchar2_table(202) := '297B612E696D6167653D627D297D297D2C642E70726F746F747970652E6765743D66756E6374696F6E2861297B76617220623D6E756C6C3B72657475726E20746869732E696D616765732E736F6D652866756E6374696F6E2863297B72657475726E2862';
wwv_flow_api.g_varchar2_table(203) := '3D63292E7372633D3D3D617D293F623A6E756C6C7D2C642E70726F746F747970652E66657463683D66756E6374696F6E2861297B72657475726E20746869732E696D616765733D612E726564756365286E28746869732E66696E644261636B67726F756E';
wwv_flow_api.g_varchar2_table(204) := '64496D6167652C74686973292C746869732E66696E64496D61676573286129292C746869732E696D616765732E666F72456163682866756E6374696F6E28612C62297B612E70726F6D6973652E7468656E2866756E6374696F6E28297B65282253756363';
wwv_flow_api.g_varchar2_table(205) := '657366756C6C79206C6F6164656420696D6167652023222B28622B31292C61297D2C66756E6374696F6E2863297B6528224661696C6564206C6F6164696E6720696D6167652023222B28622B31292C612C63297D297D292C746869732E72656164793D50';
wwv_flow_api.g_varchar2_table(206) := '726F6D6973652E616C6C28746869732E696D616765732E6D617028746869732E67657450726F6D6973652C7468697329292C65282246696E697368656420736561726368696E6720696D6167657322292C746869737D2C642E70726F746F747970652E74';
wwv_flow_api.g_varchar2_table(207) := '696D656F75743D66756E6374696F6E28612C62297B76617220632C643D50726F6D6973652E72616365285B612E70726F6D6973652C6E65772050726F6D6973652866756E6374696F6E28642C66297B633D73657454696D656F75742866756E6374696F6E';
wwv_flow_api.g_varchar2_table(208) := '28297B65282254696D6564206F7574206C6F6164696E6720696D616765222C61292C662861297D2C62297D295D292E7468656E2866756E6374696F6E2861297B72657475726E20636C65617254696D656F75742863292C617D293B72657475726E20645B';
wwv_flow_api.g_varchar2_table(209) := '226361746368225D2866756E6374696F6E28297B636C65617254696D656F75742863297D292C647D2C622E6578706F7274733D647D2C7B222E2F64756D6D79696D616765636F6E7461696E6572223A352C222E2F6672616D65636F6E7461696E6572223A';
wwv_flow_api.g_varchar2_table(210) := '382C222E2F696D616765636F6E7461696E6572223A31302C222E2F6C696E6561726772616469656E74636F6E7461696E6572223A31322C222E2F6C6F67223A31332C222E2F70726F7879696D616765636F6E7461696E6572223A31372C222E2F73766763';
wwv_flow_api.g_varchar2_table(211) := '6F6E7461696E6572223A32332C222E2F7376676E6F6465636F6E7461696E6572223A32342C222E2F7574696C73223A32362C222E2F7765626B69746772616469656E74636F6E7461696E6572223A32377D5D2C31323A5B66756E6374696F6E28612C622C';
wwv_flow_api.g_varchar2_table(212) := '63297B66756E6374696F6E20642861297B652E6170706C7928746869732C617267756D656E7473292C746869732E747970653D652E54595045532E4C494E4541523B76617220623D642E5245474558505F444952454354494F4E2E7465737428612E6172';
wwv_flow_api.g_varchar2_table(213) := '67735B305D297C7C21652E5245474558505F434F4C4F5253544F502E7465737428612E617267735B305D293B623F612E617267735B305D2E73706C6974282F5C732B2F292E7265766572736528292E666F72456163682866756E6374696F6E28612C6229';
wwv_flow_api.g_varchar2_table(214) := '7B7377697463682861297B63617365226C656674223A746869732E78303D302C746869732E78313D313B627265616B3B6361736522746F70223A746869732E79303D302C746869732E79313D313B627265616B3B63617365227269676874223A74686973';
wwv_flow_api.g_varchar2_table(215) := '2E78303D312C746869732E78313D303B627265616B3B6361736522626F74746F6D223A746869732E79303D312C746869732E79313D303B627265616B3B6361736522746F223A76617220633D746869732E79302C643D746869732E78303B746869732E79';
wwv_flow_api.g_varchar2_table(216) := '303D746869732E79312C746869732E78303D746869732E78312C746869732E78313D642C746869732E79313D633B627265616B3B636173652263656E746572223A627265616B3B64656661756C743A76617220653D2E30312A7061727365466C6F617428';
wwv_flow_api.g_varchar2_table(217) := '612C3130293B69662869734E614E28652929627265616B3B303D3D3D623F28746869732E79303D652C746869732E79313D312D746869732E7930293A28746869732E78303D652C746869732E78313D312D746869732E7830297D7D2C74686973293A2874';
wwv_flow_api.g_varchar2_table(218) := '6869732E79303D302C746869732E79313D31292C746869732E636F6C6F7253746F70733D612E617267732E736C69636528623F313A30292E6D61702866756E6374696F6E2861297B76617220623D612E6D6174636828652E5245474558505F434F4C4F52';
wwv_flow_api.g_varchar2_table(219) := '53544F50292C633D2B625B325D2C643D303D3D3D633F2225223A625B335D3B72657475726E7B636F6C6F723A6E6577206628625B315D292C73746F703A2225223D3D3D643F632F3130303A6E756C6C7D7D292C6E756C6C3D3D3D746869732E636F6C6F72';
wwv_flow_api.g_varchar2_table(220) := '53746F70735B305D2E73746F70262628746869732E636F6C6F7253746F70735B305D2E73746F703D30292C6E756C6C3D3D3D746869732E636F6C6F7253746F70735B746869732E636F6C6F7253746F70732E6C656E6774682D315D2E73746F7026262874';
wwv_flow_api.g_varchar2_table(221) := '6869732E636F6C6F7253746F70735B746869732E636F6C6F7253746F70732E6C656E6774682D315D2E73746F703D31292C746869732E636F6C6F7253746F70732E666F72456163682866756E6374696F6E28612C62297B6E756C6C3D3D3D612E73746F70';
wwv_flow_api.g_varchar2_table(222) := '2626746869732E636F6C6F7253746F70732E736C6963652862292E736F6D652866756E6374696F6E28632C64297B72657475726E206E756C6C213D3D632E73746F703F28612E73746F703D28632E73746F702D746869732E636F6C6F7253746F70735B62';
wwv_flow_api.g_varchar2_table(223) := '2D315D2E73746F70292F28642B31292B746869732E636F6C6F7253746F70735B622D315D2E73746F702C2130293A21317D2C74686973297D2C74686973297D76617220653D6128222E2F6772616469656E74636F6E7461696E657222292C663D6128222E';
wwv_flow_api.g_varchar2_table(224) := '2F636F6C6F7222293B642E70726F746F747970653D4F626A6563742E63726561746528652E70726F746F74797065292C642E5245474558505F444952454354494F4E3D2F5E5C732A283F3A746F7C6C6566747C72696768747C746F707C626F74746F6D7C';
wwv_flow_api.g_varchar2_table(225) := '63656E7465727C5C647B312C337D283F3A5C2E5C642B293F253F29283F3A5C737C24292F692C622E6578706F7274733D647D2C7B222E2F636F6C6F72223A332C222E2F6772616469656E74636F6E7461696E6572223A397D5D2C31333A5B66756E637469';
wwv_flow_api.g_varchar2_table(226) := '6F6E28612C622C63297B622E6578706F7274733D66756E6374696F6E28297B77696E646F772E68746D6C3263616E7661732E6C6F6767696E67262677696E646F772E636F6E736F6C65262677696E646F772E636F6E736F6C652E6C6F67262646756E6374';
wwv_flow_api.g_varchar2_table(227) := '696F6E2E70726F746F747970652E62696E642E63616C6C2877696E646F772E636F6E736F6C652E6C6F672C77696E646F772E636F6E736F6C65292E6170706C792877696E646F772E636F6E736F6C652C5B446174652E6E6F7728292D77696E646F772E68';
wwv_flow_api.g_varchar2_table(228) := '746D6C3263616E7661732E73746172742B226D73222C2268746D6C3263616E7661733A225D2E636F6E636174285B5D2E736C6963652E63616C6C28617267756D656E74732C302929297D7D2C7B7D5D2C31343A5B66756E6374696F6E28612C622C63297B';
wwv_flow_api.g_varchar2_table(229) := '66756E6374696F6E206428612C62297B746869732E6E6F64653D612C746869732E706172656E743D622C746869732E737461636B3D6E756C6C2C746869732E626F756E64733D6E756C6C2C746869732E626F72646572733D6E756C6C2C746869732E636C';
wwv_flow_api.g_varchar2_table(230) := '69703D5B5D2C746869732E6261636B67726F756E64436C69703D5B5D2C746869732E6F6666736574426F756E64733D6E756C6C2C746869732E76697369626C653D6E756C6C2C746869732E636F6D70757465645374796C65733D6E756C6C2C746869732E';
wwv_flow_api.g_varchar2_table(231) := '636F6C6F72733D7B7D2C746869732E7374796C65733D7B7D2C746869732E6261636B67726F756E64496D616765733D6E756C6C2C746869732E7472616E73666F726D446174613D6E756C6C2C746869732E7472616E73666F726D4D61747269783D6E756C';
wwv_flow_api.g_varchar2_table(232) := '6C2C746869732E697350736575646F456C656D656E743D21312C746869732E6F7061636974793D6E756C6C7D66756E6374696F6E20652861297B76617220623D612E6F7074696F6E735B612E73656C6563746564496E6465787C7C305D3B72657475726E';
wwv_flow_api.g_varchar2_table(233) := '20623F622E746578747C7C22223A22227D66756E6374696F6E20662861297B696628612626226D6174726978223D3D3D615B315D2972657475726E20615B325D2E73706C697428222C22292E6D61702866756E6374696F6E2861297B72657475726E2070';
wwv_flow_api.g_varchar2_table(234) := '61727365466C6F617428612E7472696D2829297D293B696628612626226D61747269783364223D3D3D615B315D297B76617220623D615B325D2E73706C697428222C22292E6D61702866756E6374696F6E2861297B72657475726E207061727365466C6F';
wwv_flow_api.g_varchar2_table(235) := '617428612E7472696D2829297D293B72657475726E5B625B305D2C625B315D2C625B345D2C625B355D2C625B31325D2C625B31335D5D7D7D66756E6374696F6E20672861297B72657475726E2D31213D3D612E746F537472696E6728292E696E6465784F';
wwv_flow_api.g_varchar2_table(236) := '6628222522297D66756E6374696F6E20682861297B72657475726E20612E7265706C61636528227078222C2222297D66756E6374696F6E20692861297B72657475726E207061727365466C6F61742861297D766172206A3D6128222E2F636F6C6F722229';
wwv_flow_api.g_varchar2_table(237) := '2C6B3D6128222E2F7574696C7322292C6C3D6B2E676574426F756E64732C6D3D6B2E70617273654261636B67726F756E64732C6E3D6B2E6F6666736574426F756E64733B642E70726F746F747970652E636C6F6E65546F3D66756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(238) := '612E76697369626C653D746869732E76697369626C652C612E626F72646572733D746869732E626F72646572732C612E626F756E64733D746869732E626F756E64732C612E636C69703D746869732E636C69702C612E6261636B67726F756E64436C6970';
wwv_flow_api.g_varchar2_table(239) := '3D746869732E6261636B67726F756E64436C69702C612E636F6D70757465645374796C65733D746869732E636F6D70757465645374796C65732C612E7374796C65733D746869732E7374796C65732C612E6261636B67726F756E64496D616765733D7468';
wwv_flow_api.g_varchar2_table(240) := '69732E6261636B67726F756E64496D616765732C612E6F7061636974793D746869732E6F7061636974797D2C642E70726F746F747970652E6765744F7061636974793D66756E6374696F6E28297B72657475726E206E756C6C3D3D3D746869732E6F7061';
wwv_flow_api.g_varchar2_table(241) := '636974793F746869732E6F7061636974793D746869732E637373466C6F617428226F70616369747922293A746869732E6F7061636974797D2C642E70726F746F747970652E61737369676E537461636B3D66756E6374696F6E2861297B746869732E7374';
wwv_flow_api.g_varchar2_table(242) := '61636B3D612C612E6368696C6472656E2E707573682874686973297D2C642E70726F746F747970652E6973456C656D656E7456697369626C653D66756E6374696F6E28297B72657475726E20746869732E6E6F64652E6E6F6465547970653D3D3D4E6F64';
wwv_flow_api.g_varchar2_table(243) := '652E544558545F4E4F44453F746869732E706172656E742E76697369626C653A226E6F6E6522213D3D746869732E6373732822646973706C6179222926262268696464656E22213D3D746869732E63737328227669736962696C69747922292626217468';
wwv_flow_api.g_varchar2_table(244) := '69732E6E6F64652E6861734174747269627574652822646174612D68746D6C3263616E7661732D69676E6F7265222926262822494E50555422213D3D746869732E6E6F64652E6E6F64654E616D657C7C2268696464656E22213D3D746869732E6E6F6465';
wwv_flow_api.g_varchar2_table(245) := '2E6765744174747269627574652822747970652229297D2C642E70726F746F747970652E6373733D66756E6374696F6E2861297B72657475726E20746869732E636F6D70757465645374796C65737C7C28746869732E636F6D70757465645374796C6573';
wwv_flow_api.g_varchar2_table(246) := '3D746869732E697350736575646F456C656D656E743F746869732E706172656E742E636F6D70757465645374796C6528746869732E6265666F72653F223A6265666F7265223A223A616674657222293A746869732E636F6D70757465645374796C65286E';
wwv_flow_api.g_varchar2_table(247) := '756C6C29292C746869732E7374796C65735B615D7C7C28746869732E7374796C65735B615D3D746869732E636F6D70757465645374796C65735B615D297D2C642E70726F746F747970652E70726566697865644373733D66756E6374696F6E2861297B76';
wwv_flow_api.g_varchar2_table(248) := '617220623D5B227765626B6974222C226D6F7A222C226D73222C226F225D2C633D746869732E6373732861293B72657475726E20766F696420303D3D3D632626622E736F6D652866756E6374696F6E2862297B72657475726E20633D746869732E637373';
wwv_flow_api.g_varchar2_table(249) := '28622B612E73756273747228302C31292E746F55707065724361736528292B612E737562737472283129292C766F69642030213D3D637D2C74686973292C766F696420303D3D3D633F6E756C6C3A637D2C642E70726F746F747970652E636F6D70757465';
wwv_flow_api.g_varchar2_table(250) := '645374796C653D66756E6374696F6E2861297B72657475726E20746869732E6E6F64652E6F776E6572446F63756D656E742E64656661756C74566965772E676574436F6D70757465645374796C6528746869732E6E6F64652C61297D2C642E70726F746F';
wwv_flow_api.g_varchar2_table(251) := '747970652E637373496E743D66756E6374696F6E2861297B76617220623D7061727365496E7428746869732E6373732861292C3130293B72657475726E2069734E614E2862293F303A627D2C642E70726F746F747970652E636F6C6F723D66756E637469';
wwv_flow_api.g_varchar2_table(252) := '6F6E2861297B72657475726E20746869732E636F6C6F72735B615D7C7C28746869732E636F6C6F72735B615D3D6E6577206A28746869732E63737328612929297D2C642E70726F746F747970652E637373466C6F61743D66756E6374696F6E2861297B76';
wwv_flow_api.g_varchar2_table(253) := '617220623D7061727365466C6F617428746869732E637373286129293B72657475726E2069734E614E2862293F303A627D2C642E70726F746F747970652E666F6E745765696768743D66756E6374696F6E28297B76617220613D746869732E6373732822';
wwv_flow_api.g_varchar2_table(254) := '666F6E7457656967687422293B737769746368287061727365496E7428612C313029297B63617365203430313A613D22626F6C64223B627265616B3B63617365203430303A613D226E6F726D616C227D72657475726E20617D2C642E70726F746F747970';
wwv_flow_api.g_varchar2_table(255) := '652E7061727365436C69703D66756E6374696F6E28297B76617220613D746869732E6373732822636C697022292E6D6174636828746869732E434C4950293B72657475726E20613F7B746F703A7061727365496E7428615B315D2C3130292C7269676874';
wwv_flow_api.g_varchar2_table(256) := '3A7061727365496E7428615B325D2C3130292C626F74746F6D3A7061727365496E7428615B335D2C3130292C6C6566743A7061727365496E7428615B345D2C3130297D3A6E756C6C7D2C642E70726F746F747970652E70617273654261636B67726F756E';
wwv_flow_api.g_varchar2_table(257) := '64496D616765733D66756E6374696F6E28297B72657475726E20746869732E6261636B67726F756E64496D616765737C7C28746869732E6261636B67726F756E64496D616765733D6D28746869732E63737328226261636B67726F756E64496D61676522';
wwv_flow_api.g_varchar2_table(258) := '2929297D2C642E70726F746F747970652E6373734C6973743D66756E6374696F6E28612C62297B76617220633D28746869732E6373732861297C7C2222292E73706C697428222C22293B72657475726E20633D635B627C7C305D7C7C635B305D7C7C2261';
wwv_flow_api.g_varchar2_table(259) := '75746F222C633D632E7472696D28292E73706C697428222022292C313D3D3D632E6C656E677468262628633D5B635B305D2C6728635B305D293F226175746F223A635B305D5D292C637D2C642E70726F746F747970652E70617273654261636B67726F75';
wwv_flow_api.g_varchar2_table(260) := '6E6453697A653D66756E6374696F6E28612C622C63297B76617220642C652C663D746869732E6373734C69737428226261636B67726F756E6453697A65222C63293B6966286728665B305D2929643D612E77696474682A7061727365466C6F617428665B';
wwv_flow_api.g_varchar2_table(261) := '305D292F3130303B656C73657B6966282F636F6E7461696E7C636F7665722F2E7465737428665B305D29297B76617220683D612E77696474682F612E6865696768742C693D622E77696474682F622E6865696768743B72657475726E20693E685E22636F';
wwv_flow_api.g_varchar2_table(262) := '6E7461696E223D3D3D665B305D3F7B77696474683A612E6865696768742A692C6865696768743A612E6865696768747D3A7B77696474683A612E77696474682C6865696768743A612E77696474682F697D7D643D7061727365496E7428665B305D2C3130';
wwv_flow_api.g_varchar2_table(263) := '297D72657475726E20653D226175746F223D3D3D665B305D2626226175746F223D3D3D665B315D3F622E6865696768743A226175746F223D3D3D665B315D3F642F622E77696474682A622E6865696768743A6728665B315D293F612E6865696768742A70';
wwv_flow_api.g_varchar2_table(264) := '61727365466C6F617428665B315D292F3130303A7061727365496E7428665B315D2C3130292C226175746F223D3D3D665B305D262628643D652F622E6865696768742A622E7769647468292C7B77696474683A642C6865696768743A657D7D2C642E7072';
wwv_flow_api.g_varchar2_table(265) := '6F746F747970652E70617273654261636B67726F756E64506F736974696F6E3D66756E6374696F6E28612C622C632C64297B76617220652C662C683D746869732E6373734C69737428226261636B67726F756E64506F736974696F6E222C63293B726574';
wwv_flow_api.g_varchar2_table(266) := '75726E20653D6728685B305D293F28612E77696474682D28647C7C62292E7769647468292A287061727365466C6F617428685B305D292F313030293A7061727365496E7428685B305D2C3130292C663D226175746F223D3D3D685B315D3F652F622E7769';
wwv_flow_api.g_varchar2_table(267) := '6474682A622E6865696768743A6728685B315D293F28612E6865696768742D28647C7C62292E686569676874292A7061727365466C6F617428685B315D292F3130303A7061727365496E7428685B315D2C3130292C226175746F223D3D3D685B305D2626';
wwv_flow_api.g_varchar2_table(268) := '28653D662F622E6865696768742A622E7769647468292C7B6C6566743A652C746F703A667D7D2C642E70726F746F747970652E70617273654261636B67726F756E645265706561743D66756E6374696F6E2861297B72657475726E20746869732E637373';
wwv_flow_api.g_varchar2_table(269) := '4C69737428226261636B67726F756E64526570656174222C61295B305D7D2C642E70726F746F747970652E706172736554657874536861646F77733D66756E6374696F6E28297B76617220613D746869732E637373282274657874536861646F7722292C';
wwv_flow_api.g_varchar2_table(270) := '623D5B5D3B696628612626226E6F6E6522213D3D6129666F722876617220633D612E6D6174636828746869732E544558545F534841444F575F50524F5045525459292C643D303B632626643C632E6C656E6774683B642B2B297B76617220653D635B645D';
wwv_flow_api.g_varchar2_table(271) := '2E6D6174636828746869732E544558545F534841444F575F56414C554553293B622E70757368287B636F6C6F723A6E6577206A28655B305D292C6F6666736574583A655B315D3F7061727365466C6F617428655B315D2E7265706C61636528227078222C';
wwv_flow_api.g_varchar2_table(272) := '222229293A302C6F6666736574593A655B325D3F7061727365466C6F617428655B325D2E7265706C61636528227078222C222229293A302C626C75723A655B335D3F655B335D2E7265706C61636528227078222C2222293A307D297D72657475726E2062';
wwv_flow_api.g_varchar2_table(273) := '7D2C642E70726F746F747970652E70617273655472616E73666F726D3D66756E6374696F6E28297B69662821746869732E7472616E73666F726D4461746129696628746869732E6861735472616E73666F726D2829297B76617220613D746869732E7061';
wwv_flow_api.g_varchar2_table(274) := '727365426F756E647328292C623D746869732E707265666978656443737328227472616E73666F726D4F726967696E22292E73706C697428222022292E6D61702868292E6D61702869293B625B305D2B3D612E6C6566742C625B315D2B3D612E746F702C';
wwv_flow_api.g_varchar2_table(275) := '746869732E7472616E73666F726D446174613D7B6F726967696E3A622C6D61747269783A746869732E70617273655472616E73666F726D4D617472697828297D7D656C736520746869732E7472616E73666F726D446174613D7B6F726967696E3A5B302C';
wwv_flow_api.g_varchar2_table(276) := '305D2C6D61747269783A5B312C302C302C312C302C305D7D3B72657475726E20746869732E7472616E73666F726D446174617D2C642E70726F746F747970652E70617273655472616E73666F726D4D61747269783D66756E6374696F6E28297B69662821';
wwv_flow_api.g_varchar2_table(277) := '746869732E7472616E73666F726D4D6174726978297B76617220613D746869732E707265666978656443737328227472616E73666F726D22292C623D613F6628612E6D6174636828746869732E4D41545249585F50524F504552545929293A6E756C6C3B';
wwv_flow_api.g_varchar2_table(278) := '746869732E7472616E73666F726D4D61747269783D623F623A5B312C302C302C312C302C305D7D72657475726E20746869732E7472616E73666F726D4D61747269787D2C642E70726F746F747970652E7061727365426F756E64733D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(279) := '28297B72657475726E20746869732E626F756E64737C7C28746869732E626F756E64733D746869732E6861735472616E73666F726D28293F6E28746869732E6E6F6465293A6C28746869732E6E6F646529297D2C642E70726F746F747970652E68617354';
wwv_flow_api.g_varchar2_table(280) := '72616E73666F726D3D66756E6374696F6E28297B72657475726E22312C302C302C312C302C3022213D3D746869732E70617273655472616E73666F726D4D617472697828292E6A6F696E28222C22297C7C746869732E706172656E742626746869732E70';
wwv_flow_api.g_varchar2_table(281) := '6172656E742E6861735472616E73666F726D28297D2C642E70726F746F747970652E67657456616C75653D66756E6374696F6E28297B76617220613D746869732E6E6F64652E76616C75657C7C22223B72657475726E2253454C454354223D3D3D746869';
wwv_flow_api.g_varchar2_table(282) := '732E6E6F64652E7461674E616D653F613D6528746869732E6E6F6465293A2270617373776F7264223D3D3D746869732E6E6F64652E74797065262628613D417272617928612E6C656E6774682B31292E6A6F696E2822E280A22229292C303D3D3D612E6C';
wwv_flow_api.g_varchar2_table(283) := '656E6774683F746869732E6E6F64652E706C616365686F6C6465727C7C22223A617D2C642E70726F746F747970652E4D41545249585F50524F50455254593D2F286D61747269787C6D61747269783364295C28282E2B295C292F2C642E70726F746F7479';
wwv_flow_api.g_varchar2_table(284) := '70652E544558545F534841444F575F50524F50455254593D2F2828726762617C726762295C285B5E5C295D2B5C29285C732D3F5C642B7078297B302C7D292F672C642E70726F746F747970652E544558545F534841444F575F56414C5545533D2F282D3F';
wwv_flow_api.g_varchar2_table(285) := '5C642B7078297C28232E2B297C287267625C282E2B5C29297C28726762615C282E2B5C29292F672C642E70726F746F747970652E434C49503D2F5E726563745C28285C642B2970782C3F20285C642B2970782C3F20285C642B2970782C3F20285C642B29';
wwv_flow_api.g_varchar2_table(286) := '70785C29242F2C622E6578706F7274733D647D2C7B222E2F636F6C6F72223A332C222E2F7574696C73223A32367D5D2C31353A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C622C632C642C65297B4F28225374617274696E';
wwv_flow_api.g_varchar2_table(287) := '67204E6F646550617273657222292C746869732E72656E64657265723D622C746869732E6F7074696F6E733D652C746869732E72616E67653D6E756C6C2C746869732E737570706F72743D632C746869732E72656E64657251756575653D5B5D2C746869';
wwv_flow_api.g_varchar2_table(288) := '732E737461636B3D6E657720562821302C312C612E6F776E6572446F63756D656E742C6E756C6C293B76617220663D6E6577205128612C6E756C6C293B696628652E6261636B67726F756E642626622E72656374616E676C6528302C302C622E77696474';
wwv_flow_api.g_varchar2_table(289) := '682C622E6865696768742C6E6577205528652E6261636B67726F756E6429292C613D3D3D612E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E74297B76617220673D6E6577205128662E636F6C6F7228226261636B67726F756E64';
wwv_flow_api.g_varchar2_table(290) := '436F6C6F7222292E69735472616E73706172656E7428293F612E6F776E6572446F63756D656E742E626F64793A612E6F776E6572446F63756D656E742E646F63756D656E74456C656D656E742C6E756C6C293B622E72656374616E676C6528302C302C62';
wwv_flow_api.g_varchar2_table(291) := '2E77696474682C622E6865696768742C672E636F6C6F7228226261636B67726F756E64436F6C6F722229297D662E7669736962696C653D662E6973456C656D656E7456697369626C6528292C746869732E63726561746550736575646F48696465537479';
wwv_flow_api.g_varchar2_table(292) := '6C657328612E6F776E6572446F63756D656E74292C746869732E64697361626C65416E696D6174696F6E7328612E6F776E6572446F63756D656E74292C746869732E6E6F6465733D4A285B665D2E636F6E63617428746869732E6765744368696C647265';
wwv_flow_api.g_varchar2_table(293) := '6E286629292E66696C7465722866756E6374696F6E2861297B72657475726E20612E76697369626C653D612E6973456C656D656E7456697369626C6528297D292E6D617028746869732E67657450736575646F456C656D656E74732C7468697329292C74';
wwv_flow_api.g_varchar2_table(294) := '6869732E666F6E744D6574726963733D6E657720542C4F282246657463686564206E6F6465732C20746F74616C3A222C746869732E6E6F6465732E6C656E677468292C4F282243616C63756C617465206F766572666C6F7720636C69707322292C746869';
wwv_flow_api.g_varchar2_table(295) := '732E63616C63756C6174654F766572666C6F77436C69707328292C4F28225374617274206665746368696E6720696D6167657322292C746869732E696D616765733D642E666574636828746869732E6E6F6465732E66696C746572284229292C74686973';
wwv_flow_api.g_varchar2_table(296) := '2E72656164793D746869732E696D616765732E72656164792E7468656E28582866756E6374696F6E28297B72657475726E204F2822496D61676573206C6F616465642C207374617274696E672070617273696E6722292C4F28224372656174696E672073';
wwv_flow_api.g_varchar2_table(297) := '7461636B696E6720636F6E746578747322292C746869732E637265617465537461636B696E67436F6E746578747328292C4F2822536F7274696E6720737461636B696E6720636F6E746578747322292C746869732E736F7274537461636B696E67436F6E';
wwv_flow_api.g_varchar2_table(298) := '746578747328746869732E737461636B292C746869732E706172736528746869732E737461636B292C4F282252656E6465722071756575652063726561746564207769746820222B746869732E72656E64657251756575652E6C656E6774682B22206974';
wwv_flow_api.g_varchar2_table(299) := '656D7322292C6E65772050726F6D69736528582866756E6374696F6E2861297B652E6173796E633F2266756E6374696F6E223D3D747970656F6620652E6173796E633F652E6173796E632E63616C6C28746869732C746869732E72656E64657251756575';
wwv_flow_api.g_varchar2_table(300) := '652C61293A746869732E72656E64657251756575652E6C656E6774683E303F28746869732E72656E646572496E6465783D302C746869732E6173796E6352656E646572657228746869732E72656E64657251756575652C6129293A6128293A2874686973';
wwv_flow_api.g_varchar2_table(301) := '2E72656E64657251756575652E666F724561636828746869732E7061696E742C74686973292C612829297D2C7468697329297D2C7468697329297D66756E6374696F6E20652861297B72657475726E20612E706172656E742626612E706172656E742E63';
wwv_flow_api.g_varchar2_table(302) := '6C69702E6C656E6774687D66756E6374696F6E20662861297B72657475726E20612E7265706C616365282F285C2D5B612D7A5D292F672C66756E6374696F6E2861297B72657475726E20612E746F55707065724361736528292E7265706C61636528222D';
wwv_flow_api.g_varchar2_table(303) := '222C2222297D297D66756E6374696F6E206728297B7D66756E6374696F6E206828612C622C632C64297B72657475726E20612E6D61702866756E6374696F6E28652C66297B696628652E77696474683E30297B76617220673D622E6C6566742C683D622E';
wwv_flow_api.g_varchar2_table(304) := '746F702C693D622E77696474682C6A3D622E6865696768742D615B325D2E77696474683B7377697463682866297B6361736520303A6A3D615B305D2E77696474682C652E617267733D6C287B63313A5B672C685D2C63323A5B672B692C685D2C63333A5B';
wwv_flow_api.g_varchar2_table(305) := '672B692D615B315D2E77696474682C682B6A5D2C63343A5B672B615B335D2E77696474682C682B6A5D7D2C645B305D2C645B315D2C632E746F704C6566744F757465722C632E746F704C656674496E6E65722C632E746F7052696768744F757465722C63';
wwv_flow_api.g_varchar2_table(306) := '2E746F705269676874496E6E6572293B627265616B3B6361736520313A673D622E6C6566742B622E77696474682D615B315D2E77696474682C693D615B315D2E77696474682C652E617267733D6C287B63313A5B672B692C685D2C63323A5B672B692C68';
wwv_flow_api.g_varchar2_table(307) := '2B6A2B615B325D2E77696474685D2C63333A5B672C682B6A5D2C63343A5B672C682B615B305D2E77696474685D7D2C645B315D2C645B325D2C632E746F7052696768744F757465722C632E746F705269676874496E6E65722C632E626F74746F6D526967';
wwv_flow_api.g_varchar2_table(308) := '68744F757465722C632E626F74746F6D5269676874496E6E6572293B627265616B3B6361736520323A683D682B622E6865696768742D615B325D2E77696474682C6A3D615B325D2E77696474682C652E617267733D6C287B63313A5B672B692C682B6A5D';
wwv_flow_api.g_varchar2_table(309) := '2C63323A5B672C682B6A5D2C63333A5B672B615B335D2E77696474682C685D2C63343A5B672B692D615B335D2E77696474682C685D7D2C645B325D2C645B335D2C632E626F74746F6D52696768744F757465722C632E626F74746F6D5269676874496E6E';
wwv_flow_api.g_varchar2_table(310) := '65722C632E626F74746F6D4C6566744F757465722C632E626F74746F6D4C656674496E6E6572293B627265616B3B6361736520333A693D615B335D2E77696474682C652E617267733D6C287B63313A5B672C682B6A2B615B325D2E77696474685D2C6332';
wwv_flow_api.g_varchar2_table(311) := '3A5B672C685D2C63333A5B672B692C682B615B305D2E77696474685D2C63343A5B672B692C682B6A5D7D2C645B335D2C645B305D2C632E626F74746F6D4C6566744F757465722C632E626F74746F6D4C656674496E6E65722C632E746F704C6566744F75';
wwv_flow_api.g_varchar2_table(312) := '7465722C632E746F704C656674496E6E6572297D7D72657475726E20657D297D66756E6374696F6E206928612C622C632C64297B76617220653D342A28284D6174682E737172742832292D31292F33292C663D632A652C673D642A652C683D612B632C69';
wwv_flow_api.g_varchar2_table(313) := '3D622B643B72657475726E7B746F704C6566743A6B287B783A612C793A697D2C7B783A612C793A692D677D2C7B783A682D662C793A627D2C7B783A682C793A627D292C746F7052696768743A6B287B783A612C793A627D2C7B783A612B662C793A627D2C';
wwv_flow_api.g_varchar2_table(314) := '7B783A682C793A692D677D2C7B783A682C793A697D292C626F74746F6D52696768743A6B287B783A682C793A627D2C7B783A682C793A622B677D2C7B783A612B662C793A697D2C7B783A612C793A697D292C626F74746F6D4C6566743A6B287B783A682C';
wwv_flow_api.g_varchar2_table(315) := '793A697D2C7B783A682D662C793A697D2C7B783A612C793A622B677D2C7B783A612C793A627D297D7D66756E6374696F6E206A28612C622C63297B76617220643D612E6C6566742C653D612E746F702C663D612E77696474682C673D612E686569676874';
wwv_flow_api.g_varchar2_table(316) := '2C683D625B305D5B305D3C662F323F625B305D5B305D3A662F322C6A3D625B305D5B315D3C672F323F625B305D5B315D3A672F322C6B3D625B315D5B305D3C662F323F625B315D5B305D3A662F322C6C3D625B315D5B315D3C672F323F625B315D5B315D';
wwv_flow_api.g_varchar2_table(317) := '3A672F322C6D3D625B325D5B305D3C662F323F625B325D5B305D3A662F322C6E3D625B325D5B315D3C672F323F625B325D5B315D3A672F322C6F3D625B335D5B305D3C662F323F625B335D5B305D3A662F322C703D625B335D5B315D3C672F323F625B33';
wwv_flow_api.g_varchar2_table(318) := '5D5B315D3A672F322C713D662D6B2C723D672D6E2C733D662D6D2C743D672D703B72657475726E7B746F704C6566744F757465723A6928642C652C682C6A292E746F704C6566742E737562646976696465282E35292C746F704C656674496E6E65723A69';
wwv_flow_api.g_varchar2_table(319) := '28642B635B335D2E77696474682C652B635B305D2E77696474682C4D6174682E6D617828302C682D635B335D2E7769647468292C4D6174682E6D617828302C6A2D635B305D2E776964746829292E746F704C6566742E737562646976696465282E35292C';
wwv_flow_api.g_varchar2_table(320) := '746F7052696768744F757465723A6928642B712C652C6B2C6C292E746F7052696768742E737562646976696465282E35292C746F705269676874496E6E65723A6928642B4D6174682E6D696E28712C662B635B335D2E7769647468292C652B635B305D2E';
wwv_flow_api.g_varchar2_table(321) := '77696474682C713E662B635B335D2E77696474683F303A6B2D635B335D2E77696474682C6C2D635B305D2E7769647468292E746F7052696768742E737562646976696465282E35292C626F74746F6D52696768744F757465723A6928642B732C652B722C';
wwv_flow_api.g_varchar2_table(322) := '6D2C6E292E626F74746F6D52696768742E737562646976696465282E35292C626F74746F6D5269676874496E6E65723A6928642B4D6174682E6D696E28732C662D635B335D2E7769647468292C652B4D6174682E6D696E28722C672B635B305D2E776964';
wwv_flow_api.g_varchar2_table(323) := '7468292C4D6174682E6D617828302C6D2D635B315D2E7769647468292C6E2D635B325D2E7769647468292E626F74746F6D52696768742E737562646976696465282E35292C0A626F74746F6D4C6566744F757465723A6928642C652B742C6F2C70292E62';
wwv_flow_api.g_varchar2_table(324) := '6F74746F6D4C6566742E737562646976696465282E35292C626F74746F6D4C656674496E6E65723A6928642B635B335D2E77696474682C652B742C4D6174682E6D617828302C6F2D635B335D2E7769647468292C702D635B325D2E7769647468292E626F';
wwv_flow_api.g_varchar2_table(325) := '74746F6D4C6566742E737562646976696465282E35297D7D66756E6374696F6E206B28612C622C632C64297B76617220653D66756E6374696F6E28612C622C63297B72657475726E7B783A612E782B28622E782D612E78292A632C793A612E792B28622E';
wwv_flow_api.g_varchar2_table(326) := '792D612E79292A637D7D3B72657475726E7B73746172743A612C7374617274436F6E74726F6C3A622C656E64436F6E74726F6C3A632C656E643A642C7375626469766964653A66756E6374696F6E2866297B76617220673D6528612C622C66292C683D65';
wwv_flow_api.g_varchar2_table(327) := '28622C632C66292C693D6528632C642C66292C6A3D6528672C682C66292C6C3D6528682C692C66292C6D3D65286A2C6C2C66293B72657475726E5B6B28612C672C6A2C6D292C6B286D2C6C2C692C64295D7D2C6375727665546F3A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(328) := '61297B612E70757368285B2262657A6965724375727665222C622E782C622E792C632E782C632E792C642E782C642E795D297D2C6375727665546F52657665727365643A66756E6374696F6E2864297B642E70757368285B2262657A6965724375727665';
wwv_flow_api.g_varchar2_table(329) := '222C632E782C632E792C622E782C622E792C612E782C612E795D297D7D7D66756E6374696F6E206C28612C622C632C642C652C662C67297B76617220683D5B5D3B72657475726E20625B305D3E307C7C625B315D3E303F28682E70757368285B226C696E';
wwv_flow_api.g_varchar2_table(330) := '65222C645B315D2E73746172742E782C645B315D2E73746172742E795D292C645B315D2E6375727665546F286829293A682E70757368285B226C696E65222C612E63315B305D2C612E63315B315D5D292C635B305D3E307C7C635B315D3E303F28682E70';
wwv_flow_api.g_varchar2_table(331) := '757368285B226C696E65222C665B305D2E73746172742E782C665B305D2E73746172742E795D292C665B305D2E6375727665546F2868292C682E70757368285B226C696E65222C675B305D2E656E642E782C675B305D2E656E642E795D292C675B305D2E';
wwv_flow_api.g_varchar2_table(332) := '6375727665546F5265766572736564286829293A28682E70757368285B226C696E65222C612E63325B305D2C612E63325B315D5D292C682E70757368285B226C696E65222C612E63335B305D2C612E63335B315D5D29292C625B305D3E307C7C625B315D';
wwv_flow_api.g_varchar2_table(333) := '3E303F28682E70757368285B226C696E65222C655B315D2E656E642E782C655B315D2E656E642E795D292C655B315D2E6375727665546F5265766572736564286829293A682E70757368285B226C696E65222C612E63345B305D2C612E63345B315D5D29';
wwv_flow_api.g_varchar2_table(334) := '2C687D66756E6374696F6E206D28612C622C632C642C652C662C67297B625B305D3E307C7C625B315D3E303F28612E70757368285B226C696E65222C645B305D2E73746172742E782C645B305D2E73746172742E795D292C645B305D2E6375727665546F';
wwv_flow_api.g_varchar2_table(335) := '2861292C645B315D2E6375727665546F286129293A612E70757368285B226C696E65222C662C675D292C28635B305D3E307C7C635B315D3E30292626612E70757368285B226C696E65222C655B305D2E73746172742E782C655B305D2E73746172742E79';
wwv_flow_api.g_varchar2_table(336) := '5D297D66756E6374696F6E206E2861297B72657475726E20612E637373496E7428227A496E64657822293C307D66756E6374696F6E206F2861297B72657475726E20612E637373496E7428227A496E64657822293E307D66756E6374696F6E2070286129';
wwv_flow_api.g_varchar2_table(337) := '7B72657475726E20303D3D3D612E637373496E7428227A496E64657822297D66756E6374696F6E20712861297B72657475726E2D31213D3D5B22696E6C696E65222C22696E6C696E652D626C6F636B222C22696E6C696E652D7461626C65225D2E696E64';
wwv_flow_api.g_varchar2_table(338) := '65784F6628612E6373732822646973706C61792229297D66756E6374696F6E20722861297B72657475726E206120696E7374616E63656F6620567D66756E6374696F6E20732861297B72657475726E20612E6E6F64652E646174612E7472696D28292E6C';
wwv_flow_api.g_varchar2_table(339) := '656E6774683E307D66756E6374696F6E20742861297B72657475726E2F5E286E6F726D616C7C6E6F6E657C30707829242F2E7465737428612E706172656E742E63737328226C657474657253706163696E672229297D66756E6374696F6E20752861297B';
wwv_flow_api.g_varchar2_table(340) := '72657475726E5B22546F704C656674222C22546F705269676874222C22426F74746F6D5269676874222C22426F74746F6D4C656674225D2E6D61702866756E6374696F6E2862297B76617220633D612E6373732822626F72646572222B622B2252616469';
wwv_flow_api.g_varchar2_table(341) := '757322292C643D632E73706C697428222022293B72657475726E20642E6C656E6774683C3D31262628645B315D3D645B305D292C642E6D61702847297D297D66756E6374696F6E20762861297B72657475726E20612E6E6F6465547970653D3D3D4E6F64';
wwv_flow_api.g_varchar2_table(342) := '652E544558545F4E4F44457C7C612E6E6F6465547970653D3D3D4E6F64652E454C454D454E545F4E4F44457D66756E6374696F6E20772861297B76617220623D612E6373732822706F736974696F6E22292C633D2D31213D3D5B226162736F6C75746522';
wwv_flow_api.g_varchar2_table(343) := '2C2272656C6174697665222C226669786564225D2E696E6465784F662862293F612E63737328227A496E64657822293A226175746F223B72657475726E226175746F22213D3D637D66756E6374696F6E20782861297B72657475726E2273746174696322';
wwv_flow_api.g_varchar2_table(344) := '213D3D612E6373732822706F736974696F6E22297D66756E6374696F6E20792861297B72657475726E226E6F6E6522213D3D612E6373732822666C6F617422297D66756E6374696F6E207A2861297B72657475726E2D31213D3D5B22696E6C696E652D62';
wwv_flow_api.g_varchar2_table(345) := '6C6F636B222C22696E6C696E652D7461626C65225D2E696E6465784F6628612E6373732822646973706C61792229297D66756E6374696F6E20412861297B76617220623D746869733B72657475726E2066756E6374696F6E28297B72657475726E21612E';
wwv_flow_api.g_varchar2_table(346) := '6170706C7928622C617267756D656E7473297D7D66756E6374696F6E20422861297B72657475726E20612E6E6F64652E6E6F6465547970653D3D3D4E6F64652E454C454D454E545F4E4F44457D66756E6374696F6E20432861297B72657475726E20612E';
wwv_flow_api.g_varchar2_table(347) := '697350736575646F456C656D656E743D3D3D21307D66756E6374696F6E20442861297B72657475726E20612E6E6F64652E6E6F6465547970653D3D3D4E6F64652E544558545F4E4F44457D66756E6374696F6E20452861297B72657475726E2066756E63';
wwv_flow_api.g_varchar2_table(348) := '74696F6E28622C63297B72657475726E20622E637373496E7428227A496E64657822292B612E696E6465784F662862292F612E6C656E6774682D28632E637373496E7428227A496E64657822292B612E696E6465784F662863292F612E6C656E67746829';
wwv_flow_api.g_varchar2_table(349) := '7D7D66756E6374696F6E20462861297B72657475726E20612E6765744F70616369747928293C317D66756E6374696F6E20472861297B72657475726E207061727365496E7428612C3130297D66756E6374696F6E20482861297B72657475726E20612E77';
wwv_flow_api.g_varchar2_table(350) := '696474687D66756E6374696F6E20492861297B72657475726E20612E6E6F64652E6E6F646554797065213D3D4E6F64652E454C454D454E545F4E4F44457C7C2D313D3D3D5B22534352495054222C2248454144222C225449544C45222C224F424A454354';
wwv_flow_api.g_varchar2_table(351) := '222C224252222C224F5054494F4E225D2E696E6465784F6628612E6E6F64652E6E6F64654E616D65297D66756E6374696F6E204A2861297B72657475726E5B5D2E636F6E6361742E6170706C79285B5D2C61297D66756E6374696F6E204B2861297B7661';
wwv_flow_api.g_varchar2_table(352) := '7220623D612E73756273747228302C31293B72657475726E20623D3D3D612E73756273747228612E6C656E6774682D31292626622E6D61746368282F277C222F293F612E73756273747228312C612E6C656E6774682D32293A617D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(353) := '4C2861297B666F722876617220622C633D5B5D2C643D302C653D21313B612E6C656E6774683B294D28615B645D293D3D3D653F28623D612E73706C69636528302C64292C622E6C656E6774682626632E7075736828502E756373322E656E636F64652862';
wwv_flow_api.g_varchar2_table(354) := '29292C653D21652C643D30293A642B2B2C643E3D612E6C656E677468262628623D612E73706C69636528302C64292C622E6C656E6774682626632E7075736828502E756373322E656E636F646528622929293B72657475726E20637D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(355) := '204D2861297B72657475726E2D31213D3D5B33322C31332C31302C392C34355D2E696E6465784F662861297D66756E6374696F6E204E2861297B72657475726E2F5B5E5C75303030302D5C75303066665D2F2E746573742861297D766172204F3D612822';
wwv_flow_api.g_varchar2_table(356) := '2E2F6C6F6722292C503D61282270756E79636F646522292C513D6128222E2F6E6F6465636F6E7461696E657222292C523D6128222E2F74657874636F6E7461696E657222292C533D6128222E2F70736575646F656C656D656E74636F6E7461696E657222';
wwv_flow_api.g_varchar2_table(357) := '292C543D6128222E2F666F6E746D65747269637322292C553D6128222E2F636F6C6F7222292C563D6128222E2F737461636B696E67636F6E7465787422292C573D6128222E2F7574696C7322292C583D572E62696E642C593D572E676574426F756E6473';
wwv_flow_api.g_varchar2_table(358) := '2C5A3D572E70617273654261636B67726F756E64732C243D572E6F6666736574426F756E64733B642E70726F746F747970652E63616C63756C6174654F766572666C6F77436C6970733D66756E6374696F6E28297B746869732E6E6F6465732E666F7245';
wwv_flow_api.g_varchar2_table(359) := '6163682866756E6374696F6E2861297B69662842286129297B432861292626612E617070656E64546F444F4D28292C612E626F72646572733D746869732E7061727365426F72646572732861293B76617220623D2268696464656E223D3D3D612E637373';
wwv_flow_api.g_varchar2_table(360) := '28226F766572666C6F7722293F5B612E626F72646572732E636C69705D3A5B5D2C633D612E7061727365436C697028293B6326262D31213D3D5B226162736F6C757465222C226669786564225D2E696E6465784F6628612E6373732822706F736974696F';
wwv_flow_api.g_varchar2_table(361) := '6E2229292626622E70757368285B5B2272656374222C612E626F756E64732E6C6566742B632E6C6566742C612E626F756E64732E746F702B632E746F702C632E72696768742D632E6C6566742C632E626F74746F6D2D632E746F705D5D292C612E636C69';
wwv_flow_api.g_varchar2_table(362) := '703D652861293F612E706172656E742E636C69702E636F6E6361742862293A622C612E6261636B67726F756E64436C69703D2268696464656E22213D3D612E63737328226F766572666C6F7722293F612E636C69702E636F6E636174285B612E626F7264';
wwv_flow_api.g_varchar2_table(363) := '6572732E636C69705D293A612E636C69702C432861292626612E636C65616E444F4D28297D656C73652044286129262628612E636C69703D652861293F612E706172656E742E636C69703A5B5D293B432861297C7C28612E626F756E64733D6E756C6C29';
wwv_flow_api.g_varchar2_table(364) := '7D2C74686973297D2C642E70726F746F747970652E6173796E6352656E64657265723D66756E6374696F6E28612C622C63297B633D637C7C446174652E6E6F7728292C746869732E7061696E7428615B746869732E72656E646572496E6465782B2B5D29';
wwv_flow_api.g_varchar2_table(365) := '2C612E6C656E6774683D3D3D746869732E72656E646572496E6465783F6228293A632B32303E446174652E6E6F7728293F746869732E6173796E6352656E646572657228612C622C63293A73657454696D656F757428582866756E6374696F6E28297B74';
wwv_flow_api.g_varchar2_table(366) := '6869732E6173796E6352656E646572657228612C62297D2C74686973292C30297D2C642E70726F746F747970652E63726561746550736575646F486964655374796C65733D66756E6374696F6E2861297B746869732E6372656174655374796C65732861';
wwv_flow_api.g_varchar2_table(367) := '2C222E222B532E70726F746F747970652E50534555444F5F484944455F454C454D454E545F434C4153535F4245464F52452B273A6265666F7265207B20636F6E74656E743A2022222021696D706F7274616E743B20646973706C61793A206E6F6E652021';
wwv_flow_api.g_varchar2_table(368) := '696D706F7274616E743B207D2E272B532E70726F746F747970652E50534555444F5F484944455F454C454D454E545F434C4153535F41465445522B273A6166746572207B20636F6E74656E743A2022222021696D706F7274616E743B20646973706C6179';
wwv_flow_api.g_varchar2_table(369) := '3A206E6F6E652021696D706F7274616E743B207D27297D2C642E70726F746F747970652E64697361626C65416E696D6174696F6E733D66756E6374696F6E2861297B746869732E6372656174655374796C657328612C222A207B202D7765626B69742D61';
wwv_flow_api.g_varchar2_table(370) := '6E696D6174696F6E3A206E6F6E652021696D706F7274616E743B202D6D6F7A2D616E696D6174696F6E3A206E6F6E652021696D706F7274616E743B202D6F2D616E696D6174696F6E3A206E6F6E652021696D706F7274616E743B20616E696D6174696F6E';
wwv_flow_api.g_varchar2_table(371) := '3A206E6F6E652021696D706F7274616E743B202D7765626B69742D7472616E736974696F6E3A206E6F6E652021696D706F7274616E743B202D6D6F7A2D7472616E736974696F6E3A206E6F6E652021696D706F7274616E743B202D6F2D7472616E736974';
wwv_flow_api.g_varchar2_table(372) := '696F6E3A206E6F6E652021696D706F7274616E743B207472616E736974696F6E3A206E6F6E652021696D706F7274616E743B7D22297D2C642E70726F746F747970652E6372656174655374796C65733D66756E6374696F6E28612C62297B76617220633D';
wwv_flow_api.g_varchar2_table(373) := '612E637265617465456C656D656E7428227374796C6522293B632E696E6E657248544D4C3D622C612E626F64792E617070656E644368696C642863297D2C642E70726F746F747970652E67657450736575646F456C656D656E74733D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(374) := '2861297B76617220623D5B5B615D5D3B696628612E6E6F64652E6E6F6465547970653D3D3D4E6F64652E454C454D454E545F4E4F4445297B76617220633D746869732E67657450736575646F456C656D656E7428612C223A6265666F726522292C643D74';
wwv_flow_api.g_varchar2_table(375) := '6869732E67657450736575646F456C656D656E7428612C223A616674657222293B632626622E707573682863292C642626622E707573682864297D72657475726E204A2862297D2C642E70726F746F747970652E67657450736575646F456C656D656E74';
wwv_flow_api.g_varchar2_table(376) := '3D66756E6374696F6E28612C62297B76617220633D612E636F6D70757465645374796C652862293B69662821637C7C21632E636F6E74656E747C7C226E6F6E65223D3D3D632E636F6E74656E747C7C222D6D6F7A2D616C742D636F6E74656E74223D3D3D';
wwv_flow_api.g_varchar2_table(377) := '632E636F6E74656E747C7C226E6F6E65223D3D3D632E646973706C61792972657475726E206E756C6C3B666F722876617220643D4B28632E636F6E74656E74292C653D2275726C223D3D3D642E73756273747228302C33292C673D646F63756D656E742E';
wwv_flow_api.g_varchar2_table(378) := '637265617465456C656D656E7428653F22696D67223A2268746D6C3263616E76617370736575646F656C656D656E7422292C683D6E6577205328672C612C62292C693D632E6C656E6774682D313B693E3D303B692D2D297B766172206A3D6628632E6974';
wwv_flow_api.g_varchar2_table(379) := '656D286929293B672E7374796C655B6A5D3D635B6A5D7D696628672E636C6173734E616D653D532E70726F746F747970652E50534555444F5F484944455F454C454D454E545F434C4153535F4245464F52452B2220222B532E70726F746F747970652E50';
wwv_flow_api.g_varchar2_table(380) := '534555444F5F484944455F454C454D454E545F434C4153535F41465445522C652972657475726E20672E7372633D5A2864295B305D2E617267735B305D2C5B685D3B766172206B3D646F63756D656E742E637265617465546578744E6F64652864293B72';
wwv_flow_api.g_varchar2_table(381) := '657475726E20672E617070656E644368696C64286B292C5B682C6E65772052286B2C68295D7D2C642E70726F746F747970652E6765744368696C6472656E3D66756E6374696F6E2861297B72657475726E204A285B5D2E66696C7465722E63616C6C2861';
wwv_flow_api.g_varchar2_table(382) := '2E6E6F64652E6368696C644E6F6465732C76292E6D61702866756E6374696F6E2862297B76617220633D5B622E6E6F6465547970653D3D3D4E6F64652E544558545F4E4F44453F6E6577205228622C61293A6E6577205128622C61295D2E66696C746572';
wwv_flow_api.g_varchar2_table(383) := '2849293B72657475726E20622E6E6F6465547970653D3D3D4E6F64652E454C454D454E545F4E4F44452626632E6C656E677468262622544558544152454122213D3D622E7461674E616D653F635B305D2E6973456C656D656E7456697369626C6528293F';
wwv_flow_api.g_varchar2_table(384) := '632E636F6E63617428746869732E6765744368696C6472656E28635B305D29293A5B5D3A637D2C7468697329297D2C642E70726F746F747970652E6E6577537461636B696E67436F6E746578743D66756E6374696F6E28612C62297B76617220633D6E65';
wwv_flow_api.g_varchar2_table(385) := '77205628622C612E6765744F70616369747928292C612E6E6F64652C612E706172656E74293B612E636C6F6E65546F2863293B76617220643D623F632E676574506172656E74537461636B2874686973293A632E706172656E742E737461636B3B642E63';
wwv_flow_api.g_varchar2_table(386) := '6F6E74657874732E707573682863292C612E737461636B3D637D2C642E70726F746F747970652E637265617465537461636B696E67436F6E74657874733D66756E6374696F6E28297B746869732E6E6F6465732E666F72456163682866756E6374696F6E';
wwv_flow_api.g_varchar2_table(387) := '2861297B42286129262628746869732E6973526F6F74456C656D656E742861297C7C462861297C7C772861297C7C746869732E6973426F6479576974685472616E73706172656E74526F6F742861297C7C612E6861735472616E73666F726D2829293F74';
wwv_flow_api.g_varchar2_table(388) := '6869732E6E6577537461636B696E67436F6E7465787428612C2130293A42286129262628782861292626702861297C7C7A2861297C7C79286129293F746869732E6E6577537461636B696E67436F6E7465787428612C2131293A612E61737369676E5374';
wwv_flow_api.g_varchar2_table(389) := '61636B28612E706172656E742E737461636B297D2C74686973297D2C642E70726F746F747970652E6973426F6479576974685472616E73706172656E74526F6F743D66756E6374696F6E2861297B72657475726E22424F4459223D3D3D612E6E6F64652E';
wwv_flow_api.g_varchar2_table(390) := '6E6F64654E616D652626612E706172656E742E636F6C6F7228226261636B67726F756E64436F6C6F7222292E69735472616E73706172656E7428297D2C642E70726F746F747970652E6973526F6F74456C656D656E743D66756E6374696F6E2861297B72';
wwv_flow_api.g_varchar2_table(391) := '657475726E206E756C6C3D3D3D612E706172656E747D2C642E70726F746F747970652E736F7274537461636B696E67436F6E74657874733D66756E6374696F6E2861297B612E636F6E74657874732E736F7274284528612E636F6E74657874732E736C69';
wwv_flow_api.g_varchar2_table(392) := '636528302929292C612E636F6E74657874732E666F724561636828746869732E736F7274537461636B696E67436F6E74657874732C74686973297D2C642E70726F746F747970652E706172736554657874426F756E64733D66756E6374696F6E2861297B';
wwv_flow_api.g_varchar2_table(393) := '72657475726E2066756E6374696F6E28622C632C64297B696628226E6F6E6522213D3D612E706172656E742E6373732822746578744465636F726174696F6E22292E73756273747228302C34297C7C30213D3D622E7472696D28292E6C656E677468297B';
wwv_flow_api.g_varchar2_table(394) := '696628746869732E737570706F72742E72616E6765426F756E6473262621612E706172656E742E6861735472616E73666F726D2829297B76617220653D642E736C69636528302C63292E6A6F696E282222292E6C656E6774683B72657475726E20746869';
wwv_flow_api.g_varchar2_table(395) := '732E67657452616E6765426F756E647328612E6E6F64652C652C622E6C656E677468297D696628612E6E6F6465262622737472696E67223D3D747970656F6620612E6E6F64652E64617461297B76617220663D612E6E6F64652E73706C69745465787428';
wwv_flow_api.g_varchar2_table(396) := '622E6C656E677468292C673D746869732E67657457726170706572426F756E647328612E6E6F64652C612E706172656E742E6861735472616E73666F726D2829293B72657475726E20612E6E6F64653D662C677D7D656C73652821746869732E73757070';
wwv_flow_api.g_varchar2_table(397) := '6F72742E72616E6765426F756E64737C7C612E706172656E742E6861735472616E73666F726D282929262628612E6E6F64653D612E6E6F64652E73706C69745465787428622E6C656E67746829293B72657475726E7B7D7D7D2C642E70726F746F747970';
wwv_flow_api.g_varchar2_table(398) := '652E67657457726170706572426F756E64733D66756E6374696F6E28612C62297B76617220633D612E6F776E6572446F63756D656E742E637265617465456C656D656E74282268746D6C3263616E7661737772617070657222292C643D612E706172656E';
wwv_flow_api.g_varchar2_table(399) := '744E6F64652C653D612E636C6F6E654E6F6465282130293B632E617070656E644368696C6428612E636C6F6E654E6F646528213029292C642E7265706C6163654368696C6428632C61293B76617220663D623F242863293A592863293B72657475726E20';
wwv_flow_api.g_varchar2_table(400) := '642E7265706C6163654368696C6428652C63292C667D2C642E70726F746F747970652E67657452616E6765426F756E64733D66756E6374696F6E28612C622C63297B76617220643D746869732E72616E67657C7C28746869732E72616E67653D612E6F77';
wwv_flow_api.g_varchar2_table(401) := '6E6572446F63756D656E742E63726561746552616E67652829293B72657475726E20642E736574537461727428612C62292C642E736574456E6428612C622B63292C642E676574426F756E64696E67436C69656E745265637428297D2C642E70726F746F';
wwv_flow_api.g_varchar2_table(402) := '747970652E70617273653D66756E6374696F6E2861297B76617220623D612E636F6E74657874732E66696C746572286E292C633D612E6368696C6472656E2E66696C7465722842292C643D632E66696C7465722841287929292C653D642E66696C746572';
wwv_flow_api.g_varchar2_table(403) := '2841287829292E66696C7465722841287129292C663D632E66696C7465722841287829292E66696C7465722879292C683D642E66696C7465722841287829292E66696C7465722871292C693D612E636F6E74657874732E636F6E63617428642E66696C74';
wwv_flow_api.g_varchar2_table(404) := '6572287829292E66696C7465722870292C6A3D612E6368696C6472656E2E66696C7465722844292E66696C7465722873292C6B3D612E636F6E74657874732E66696C746572286F293B622E636F6E6361742865292E636F6E6361742866292E636F6E6361';
wwv_flow_api.g_varchar2_table(405) := '742868292E636F6E6361742869292E636F6E636174286A292E636F6E636174286B292E666F72456163682866756E6374696F6E2861297B746869732E72656E64657251756575652E707573682861292C72286129262628746869732E7061727365286129';
wwv_flow_api.g_varchar2_table(406) := '2C746869732E72656E64657251756575652E70757368286E6577206729297D2C74686973297D2C642E70726F746F747970652E7061696E743D66756E6374696F6E2861297B7472797B6120696E7374616E63656F6620673F746869732E72656E64657265';
wwv_flow_api.g_varchar2_table(407) := '722E6374782E726573746F726528293A442861293F284328612E706172656E74292626612E706172656E742E617070656E64546F444F4D28292C746869732E7061696E74546578742861292C4328612E706172656E74292626612E706172656E742E636C';
wwv_flow_api.g_varchar2_table(408) := '65616E444F4D2829293A746869732E7061696E744E6F64652861297D63617463682862297B6966284F2862292C746869732E6F7074696F6E732E737472696374297468726F7720627D7D2C642E70726F746F747970652E7061696E744E6F64653D66756E';
wwv_flow_api.g_varchar2_table(409) := '6374696F6E2861297B72286129262628746869732E72656E64657265722E7365744F70616369747928612E6F706163697479292C746869732E72656E64657265722E6374782E7361766528292C612E6861735472616E73666F726D28292626746869732E';
wwv_flow_api.g_varchar2_table(410) := '72656E64657265722E7365745472616E73666F726D28612E70617273655472616E73666F726D282929292C22494E505554223D3D3D612E6E6F64652E6E6F64654E616D65262622636865636B626F78223D3D3D612E6E6F64652E747970653F746869732E';
wwv_flow_api.g_varchar2_table(411) := '7061696E74436865636B626F782861293A22494E505554223D3D3D612E6E6F64652E6E6F64654E616D65262622726164696F223D3D3D612E6E6F64652E747970653F746869732E7061696E74526164696F2861293A746869732E7061696E74456C656D65';
wwv_flow_api.g_varchar2_table(412) := '6E742861297D2C642E70726F746F747970652E7061696E74456C656D656E743D66756E6374696F6E2861297B76617220623D612E7061727365426F756E647328293B746869732E72656E64657265722E636C697028612E6261636B67726F756E64436C69';
wwv_flow_api.g_varchar2_table(413) := '702C66756E6374696F6E28297B746869732E72656E64657265722E72656E6465724261636B67726F756E6428612C622C612E626F72646572732E626F72646572732E6D6170284829297D2C74686973292C746869732E72656E64657265722E636C697028';
wwv_flow_api.g_varchar2_table(414) := '612E636C69702C66756E6374696F6E28297B746869732E72656E64657265722E72656E646572426F726465727328612E626F72646572732E626F7264657273297D2C74686973292C746869732E72656E64657265722E636C697028612E6261636B67726F';
wwv_flow_api.g_varchar2_table(415) := '756E64436C69702C66756E6374696F6E28297B73776974636828612E6E6F64652E6E6F64654E616D65297B6361736522737667223A6361736522494652414D45223A76617220633D746869732E696D616765732E67657428612E6E6F6465293B633F7468';
wwv_flow_api.g_varchar2_table(416) := '69732E72656E64657265722E72656E646572496D61676528612C622C612E626F72646572732C63293A4F28224572726F72206C6F6164696E67203C222B612E6E6F64652E6E6F64654E616D652B223E222C612E6E6F6465293B627265616B3B6361736522';
wwv_flow_api.g_varchar2_table(417) := '494D47223A76617220643D746869732E696D616765732E67657428612E6E6F64652E737263293B643F746869732E72656E64657265722E72656E646572496D61676528612C622C612E626F72646572732C64293A4F28224572726F72206C6F6164696E67';
wwv_flow_api.g_varchar2_table(418) := '203C696D673E222C612E6E6F64652E737263293B627265616B3B636173652243414E564153223A746869732E72656E64657265722E72656E646572496D61676528612C622C612E626F72646572732C7B696D6167653A612E6E6F64657D293B627265616B';
wwv_flow_api.g_varchar2_table(419) := '3B636173652253454C454354223A6361736522494E505554223A63617365225445585441524541223A746869732E7061696E74466F726D56616C75652861297D7D2C74686973297D2C642E70726F746F747970652E7061696E74436865636B626F783D66';
wwv_flow_api.g_varchar2_table(420) := '756E6374696F6E2861297B76617220623D612E7061727365426F756E647328292C633D4D6174682E6D696E28622E77696474682C622E686569676874292C643D7B77696474683A632D312C6865696768743A632D312C746F703A622E746F702C6C656674';
wwv_flow_api.g_varchar2_table(421) := '3A622E6C6566747D2C653D5B332C335D2C663D5B652C652C652C655D2C673D5B312C312C312C315D2E6D61702866756E6374696F6E2861297B72657475726E7B636F6C6F723A6E6577205528222341354135413522292C77696474683A617D7D292C693D';
wwv_flow_api.g_varchar2_table(422) := '6A28642C662C67293B746869732E72656E64657265722E636C697028612E6261636B67726F756E64436C69702C66756E6374696F6E28297B746869732E72656E64657265722E72656374616E676C6528642E6C6566742B312C642E746F702B312C642E77';
wwv_flow_api.g_varchar2_table(423) := '696474682D322C642E6865696768742D322C6E657720552822234445444544452229292C746869732E72656E64657265722E72656E646572426F7264657273286828672C642C692C6629292C612E6E6F64652E636865636B6564262628746869732E7265';
wwv_flow_api.g_varchar2_table(424) := '6E64657265722E666F6E74286E6577205528222334323432343222292C226E6F726D616C222C226E6F726D616C222C22626F6C64222C632D332B227078222C22617269616C22292C746869732E72656E64657265722E746578742822E29C94222C642E6C';
wwv_flow_api.g_varchar2_table(425) := '6566742B632F362C642E746F702B632D3129297D2C74686973297D2C642E70726F746F747970652E7061696E74526164696F3D66756E6374696F6E2861297B76617220623D612E7061727365426F756E647328292C633D4D6174682E6D696E28622E7769';
wwv_flow_api.g_varchar2_table(426) := '6474682C622E686569676874292D323B746869732E72656E64657265722E636C697028612E6261636B67726F756E64436C69702C66756E6374696F6E28297B746869732E72656E64657265722E636972636C655374726F6B6528622E6C6566742B312C62';
wwv_flow_api.g_varchar2_table(427) := '2E746F702B312C632C6E6577205528222344454445444522292C312C6E657720552822234135413541352229292C612E6E6F64652E636865636B65642626746869732E72656E64657265722E636972636C65284D6174682E6365696C28622E6C6566742B';
wwv_flow_api.g_varchar2_table(428) := '632F34292B312C4D6174682E6365696C28622E746F702B632F34292B312C4D6174682E666C6F6F7228632F32292C6E657720552822233432343234322229297D2C74686973297D2C642E70726F746F747970652E7061696E74466F726D56616C75653D66';
wwv_flow_api.g_varchar2_table(429) := '756E6374696F6E2861297B76617220623D612E67657456616C756528293B696628622E6C656E6774683E30297B76617220633D612E6E6F64652E6F776E6572446F63756D656E742C643D632E637265617465456C656D656E74282268746D6C3263616E76';
wwv_flow_api.g_varchar2_table(430) := '61737772617070657222292C653D5B226C696E65486569676874222C2274657874416C69676E222C22666F6E7446616D696C79222C22666F6E74576569676874222C22666F6E7453697A65222C22636F6C6F72222C2270616464696E674C656674222C22';
wwv_flow_api.g_varchar2_table(431) := '70616464696E67546F70222C2270616464696E675269676874222C2270616464696E67426F74746F6D222C227769647468222C22686569676874222C22626F726465724C6566745374796C65222C22626F72646572546F705374796C65222C22626F7264';
wwv_flow_api.g_varchar2_table(432) := '65724C6566745769647468222C22626F72646572546F705769647468222C22626F7853697A696E67222C2277686974655370616365222C22776F726457726170225D3B652E666F72456163682866756E6374696F6E2862297B7472797B642E7374796C65';
wwv_flow_api.g_varchar2_table(433) := '5B625D3D612E6373732862297D63617463682863297B4F282268746D6C3263616E7661733A2050617273653A20457863657074696F6E2063617567687420696E2072656E646572466F726D56616C75653A20222B632E6D657373616765297D7D293B7661';
wwv_flow_api.g_varchar2_table(434) := '7220663D612E7061727365426F756E647328293B642E7374796C652E706F736974696F6E3D226669786564222C642E7374796C652E6C6566743D662E6C6566742B227078222C642E7374796C652E746F703D662E746F702B227078222C642E7465787443';
wwv_flow_api.g_varchar2_table(435) := '6F6E74656E743D622C632E626F64792E617070656E644368696C642864292C746869732E7061696E7454657874286E6577205228642E66697273744368696C642C6129292C632E626F64792E72656D6F76654368696C642864297D7D2C642E70726F746F';
wwv_flow_api.g_varchar2_table(436) := '747970652E7061696E74546578743D66756E6374696F6E2861297B612E6170706C79546578745472616E73666F726D28293B76617220623D502E756373322E6465636F646528612E6E6F64652E64617461292C633D746869732E6F7074696F6E732E6C65';
wwv_flow_api.g_varchar2_table(437) := '7474657252656E646572696E67262621742861297C7C4E28612E6E6F64652E64617461293F622E6D61702866756E6374696F6E2861297B72657475726E20502E756373322E656E636F6465285B615D297D293A4C2862292C643D612E706172656E742E66';
wwv_flow_api.g_varchar2_table(438) := '6F6E7457656967687428292C653D612E706172656E742E6373732822666F6E7453697A6522292C663D612E706172656E742E6373732822666F6E7446616D696C7922292C673D612E706172656E742E706172736554657874536861646F777328293B7468';
wwv_flow_api.g_varchar2_table(439) := '69732E72656E64657265722E666F6E7428612E706172656E742E636F6C6F722822636F6C6F7222292C612E706172656E742E6373732822666F6E745374796C6522292C612E706172656E742E6373732822666F6E7456617269616E7422292C642C652C66';
wwv_flow_api.g_varchar2_table(440) := '292C672E6C656E6774683F746869732E72656E64657265722E666F6E74536861646F7728675B305D2E636F6C6F722C675B305D2E6F6666736574582C675B305D2E6F6666736574592C675B305D2E626C7572293A746869732E72656E64657265722E636C';
wwv_flow_api.g_varchar2_table(441) := '656172536861646F7728292C746869732E72656E64657265722E636C697028612E706172656E742E636C69702C66756E6374696F6E28297B632E6D617028746869732E706172736554657874426F756E64732861292C74686973292E666F724561636828';
wwv_flow_api.g_varchar2_table(442) := '66756E6374696F6E28622C64297B62262628746869732E72656E64657265722E7465787428635B645D2C622E6C6566742C622E626F74746F6D292C746869732E72656E646572546578744465636F726174696F6E28612E706172656E742C622C74686973';
wwv_flow_api.g_varchar2_table(443) := '2E666F6E744D6574726963732E6765744D65747269637328662C652929297D2C74686973297D2C74686973297D2C642E70726F746F747970652E72656E646572546578744465636F726174696F6E3D66756E6374696F6E28612C622C63297B7377697463';
wwv_flow_api.g_varchar2_table(444) := '6828612E6373732822746578744465636F726174696F6E22292E73706C697428222022295B305D297B6361736522756E6465726C696E65223A746869732E72656E64657265722E72656374616E676C6528622E6C6566742C4D6174682E726F756E642862';
wwv_flow_api.g_varchar2_table(445) := '2E746F702B632E626173656C696E652B632E6C696E655769647468292C622E77696474682C312C612E636F6C6F722822636F6C6F722229293B627265616B3B63617365226F7665726C696E65223A746869732E72656E64657265722E72656374616E676C';
wwv_flow_api.g_varchar2_table(446) := '6528622E6C6566742C4D6174682E726F756E6428622E746F70292C622E77696474682C312C612E636F6C6F722822636F6C6F722229293B627265616B3B63617365226C696E652D7468726F756768223A746869732E72656E64657265722E72656374616E';
wwv_flow_api.g_varchar2_table(447) := '676C6528622E6C6566742C4D6174682E6365696C28622E746F702B632E6D6964646C652B632E6C696E655769647468292C622E77696474682C312C612E636F6C6F722822636F6C6F722229297D7D3B766172205F3D7B696E7365743A5B5B226461726B65';
wwv_flow_api.g_varchar2_table(448) := '6E222C2E365D2C5B226461726B656E222C2E315D2C5B226461726B656E222C2E315D2C5B226461726B656E222C2E365D5D7D3B642E70726F746F747970652E7061727365426F72646572733D66756E6374696F6E2861297B76617220623D612E70617273';
wwv_flow_api.g_varchar2_table(449) := '65426F756E647328292C633D752861292C643D5B22546F70222C225269676874222C22426F74746F6D222C224C656674225D2E6D61702866756E6374696F6E28622C63297B76617220643D612E6373732822626F72646572222B622B225374796C652229';
wwv_flow_api.g_varchar2_table(450) := '2C653D612E636F6C6F722822626F72646572222B622B22436F6C6F7222293B22696E736574223D3D3D642626652E6973426C61636B2829262628653D6E65772055285B3235352C3235352C3235352C652E615D29293B76617220663D5F5B645D3F5F5B64';
wwv_flow_api.g_varchar2_table(451) := '5D5B635D3A6E756C6C3B72657475726E7B77696474683A612E637373496E742822626F72646572222B622B22576964746822292C636F6C6F723A663F655B665B305D5D28665B315D293A652C617267733A6E756C6C7D7D292C653D6A28622C632C64293B';
wwv_flow_api.g_varchar2_table(452) := '72657475726E7B636C69703A746869732E70617273654261636B67726F756E64436C697028612C652C642C632C62292C626F72646572733A6828642C622C652C63297D7D2C642E70726F746F747970652E70617273654261636B67726F756E64436C6970';
wwv_flow_api.g_varchar2_table(453) := '3D66756E6374696F6E28612C622C632C642C65297B76617220663D612E63737328226261636B67726F756E64436C697022292C673D5B5D3B7377697463682866297B6361736522636F6E74656E742D626F78223A636173652270616464696E672D626F78';
wwv_flow_api.g_varchar2_table(454) := '223A6D28672C645B305D2C645B315D2C622E746F704C656674496E6E65722C622E746F705269676874496E6E65722C652E6C6566742B635B335D2E77696474682C652E746F702B635B305D2E7769647468292C6D28672C645B315D2C645B325D2C622E74';
wwv_flow_api.g_varchar2_table(455) := '6F705269676874496E6E65722C622E626F74746F6D5269676874496E6E65722C652E6C6566742B652E77696474682D635B315D2E77696474682C652E746F702B635B305D2E7769647468292C6D28672C645B325D2C645B335D2C622E626F74746F6D5269';
wwv_flow_api.g_varchar2_table(456) := '676874496E6E65722C622E626F74746F6D4C656674496E6E65722C652E6C6566742B652E77696474682D635B315D2E77696474682C652E746F702B652E6865696768742D635B325D2E7769647468292C6D28672C645B335D2C645B305D2C622E626F7474';
wwv_flow_api.g_varchar2_table(457) := '6F6D4C656674496E6E65722C622E746F704C656674496E6E65722C652E6C6566742B635B335D2E77696474682C652E746F702B652E6865696768742D635B325D2E7769647468293B627265616B3B64656661756C743A6D28672C645B305D2C645B315D2C';
wwv_flow_api.g_varchar2_table(458) := '622E746F704C6566744F757465722C622E746F7052696768744F757465722C652E6C6566742C652E746F70292C6D28672C645B315D2C645B325D2C622E746F7052696768744F757465722C622E626F74746F6D52696768744F757465722C652E6C656674';
wwv_flow_api.g_varchar2_table(459) := '2B652E77696474682C652E746F70292C6D28672C645B325D2C645B335D2C622E626F74746F6D52696768744F757465722C622E626F74746F6D4C6566744F757465722C652E6C6566742B652E77696474682C652E746F702B652E686569676874292C6D28';
wwv_flow_api.g_varchar2_table(460) := '672C645B335D2C645B305D2C622E626F74746F6D4C6566744F757465722C622E746F704C6566744F757465722C652E6C6566742C652E746F702B652E686569676874297D72657475726E20677D2C622E6578706F7274733D647D2C7B222E2F636F6C6F72';
wwv_flow_api.g_varchar2_table(461) := '223A332C222E2F666F6E746D657472696373223A372C222E2F6C6F67223A31332C222E2F6E6F6465636F6E7461696E6572223A31342C222E2F70736575646F656C656D656E74636F6E7461696E6572223A31382C222E2F737461636B696E67636F6E7465';
wwv_flow_api.g_varchar2_table(462) := '7874223A32312C222E2F74657874636F6E7461696E6572223A32352C222E2F7574696C73223A32362C70756E79636F64653A317D5D2C31363A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C622C63297B76617220643D2277';
wwv_flow_api.g_varchar2_table(463) := '69746843726564656E7469616C7322696E206E657720584D4C48747470526571756573743B69662821622972657475726E2050726F6D6973652E72656A65637428224E6F2070726F787920636F6E6669677572656422293B76617220653D672864292C69';
wwv_flow_api.g_varchar2_table(464) := '3D6828622C612C65293B72657475726E20643F6B2869293A6628632C692C65292E7468656E2866756E6374696F6E2861297B72657475726E206F28612E636F6E74656E74297D297D66756E6374696F6E206528612C622C63297B76617220643D2263726F';
wwv_flow_api.g_varchar2_table(465) := '73734F726967696E22696E206E657720496D6167652C653D672864292C693D6828622C612C65293B72657475726E20643F50726F6D6973652E7265736F6C76652869293A6628632C692C65292E7468656E2866756E6374696F6E2861297B72657475726E';
wwv_flow_api.g_varchar2_table(466) := '22646174613A222B612E747970652B223B6261736536342C222B612E636F6E74656E747D297D66756E6374696F6E206628612C622C63297B72657475726E206E65772050726F6D6973652866756E6374696F6E28642C65297B76617220663D612E637265';
wwv_flow_api.g_varchar2_table(467) := '617465456C656D656E74282273637269707422292C673D66756E6374696F6E28297B64656C6574652077696E646F772E68746D6C3263616E7661732E70726F78795B635D2C612E626F64792E72656D6F76654368696C642866297D3B77696E646F772E68';
wwv_flow_api.g_varchar2_table(468) := '746D6C3263616E7661732E70726F78795B635D3D66756E6374696F6E2861297B6728292C642861297D2C662E7372633D622C662E6F6E6572726F723D66756E6374696F6E2861297B6728292C652861297D2C612E626F64792E617070656E644368696C64';
wwv_flow_api.g_varchar2_table(469) := '2866297D297D66756E6374696F6E20672861297B72657475726E20613F22223A2268746D6C3263616E7661735F222B446174652E6E6F7728292B225F222B202B2B702B225F222B4D6174682E726F756E64283165352A4D6174682E72616E646F6D282929';
wwv_flow_api.g_varchar2_table(470) := '7D66756E6374696F6E206828612C622C63297B72657475726E20612B223F75726C3D222B656E636F6465555249436F6D706F6E656E742862292B28632E6C656E6774683F222663616C6C6261636B3D68746D6C3263616E7661732E70726F78792E222B63';
wwv_flow_api.g_varchar2_table(471) := '3A2222297D66756E6374696F6E20692861297B72657475726E2066756E6374696F6E2862297B76617220632C643D6E657720444F4D5061727365723B7472797B633D642E706172736546726F6D537472696E6728622C22746578742F68746D6C22297D63';
wwv_flow_api.g_varchar2_table(472) := '617463682865297B6D2822444F4D506172736572206E6F7420737570706F727465642C2066616C6C696E67206261636B20746F2063726561746548544D4C446F63756D656E7422292C633D646F63756D656E742E696D706C656D656E746174696F6E2E63';
wwv_flow_api.g_varchar2_table(473) := '726561746548544D4C446F63756D656E74282222293B7472797B632E6F70656E28292C632E77726974652862292C632E636C6F736528297D63617463682866297B6D282263726561746548544D4C446F63756D656E74207772697465206E6F7420737570';
wwv_flow_api.g_varchar2_table(474) := '706F727465642C2066616C6C696E67206261636B20746F20646F63756D656E742E626F64792E696E6E657248544D4C22292C632E626F64792E696E6E657248544D4C3D627D7D76617220673D632E717565727953656C6563746F7228226261736522293B';
wwv_flow_api.g_varchar2_table(475) := '69662821677C7C21672E687265662E686F7374297B76617220683D632E637265617465456C656D656E7428226261736522293B682E687265663D612C632E686561642E696E736572744265666F726528682C632E686561642E66697273744368696C6429';
wwv_flow_api.g_varchar2_table(476) := '7D72657475726E20637D7D66756E6374696F6E206A28612C622C632C652C662C67297B72657475726E206E6577206428612C622C77696E646F772E646F63756D656E74292E7468656E2869286129292E7468656E2866756E6374696F6E2861297B726574';
wwv_flow_api.g_varchar2_table(477) := '75726E206E28612C632C652C662C672C302C30297D297D766172206B3D6128222E2F78687222292C6C3D6128222E2F7574696C7322292C6D3D6128222E2F6C6F6722292C6E3D6128222E2F636C6F6E6522292C6F3D6C2E6465636F646536342C703D303B';
wwv_flow_api.g_varchar2_table(478) := '632E50726F78793D642C632E50726F787955524C3D652C632E6C6F616455726C446F63756D656E743D6A7D2C7B222E2F636C6F6E65223A322C222E2F6C6F67223A31332C222E2F7574696C73223A32362C222E2F786872223A32387D5D2C31373A5B6675';
wwv_flow_api.g_varchar2_table(479) := '6E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B76617220633D646F63756D656E742E637265617465456C656D656E7428226122293B632E687265663D612C613D632E687265662C746869732E7372633D612C746869732E696D';
wwv_flow_api.g_varchar2_table(480) := '6167653D6E657720496D6167653B76617220643D746869733B746869732E70726F6D6973653D6E65772050726F6D6973652866756E6374696F6E28632C66297B642E696D6167652E63726F73734F726967696E3D22416E6F6E796D6F7573222C642E696D';
wwv_flow_api.g_varchar2_table(481) := '6167652E6F6E6C6F61643D632C642E696D6167652E6F6E6572726F723D662C6E6577206528612C622C646F63756D656E74292E7468656E2866756E6374696F6E2861297B642E696D6167652E7372633D617D295B226361746368225D2866297D297D7661';
wwv_flow_api.g_varchar2_table(482) := '7220653D6128222E2F70726F787922292E50726F787955524C3B622E6578706F7274733D647D2C7B222E2F70726F7879223A31367D5D2C31383A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C622C63297B652E63616C6C28';
wwv_flow_api.g_varchar2_table(483) := '746869732C612C62292C746869732E697350736575646F456C656D656E743D21302C746869732E6265666F72653D223A6265666F7265223D3D3D637D76617220653D6128222E2F6E6F6465636F6E7461696E657222293B642E70726F746F747970652E63';
wwv_flow_api.g_varchar2_table(484) := '6C6F6E65546F3D66756E6374696F6E2861297B642E70726F746F747970652E636C6F6E65546F2E63616C6C28746869732C61292C612E697350736575646F456C656D656E743D21302C612E6265666F72653D746869732E6265666F72657D2C642E70726F';
wwv_flow_api.g_varchar2_table(485) := '746F747970653D4F626A6563742E63726561746528652E70726F746F74797065292C642E70726F746F747970652E617070656E64546F444F4D3D66756E6374696F6E28297B746869732E6265666F72653F746869732E706172656E742E6E6F64652E696E';
wwv_flow_api.g_varchar2_table(486) := '736572744265666F726528746869732E6E6F64652C746869732E706172656E742E6E6F64652E66697273744368696C64293A746869732E706172656E742E6E6F64652E617070656E644368696C6428746869732E6E6F6465292C746869732E706172656E';
wwv_flow_api.g_varchar2_table(487) := '742E6E6F64652E636C6173734E616D652B3D2220222B746869732E67657448696465436C61737328297D2C642E70726F746F747970652E636C65616E444F4D3D66756E6374696F6E28297B746869732E6E6F64652E706172656E744E6F64652E72656D6F';
wwv_flow_api.g_varchar2_table(488) := '76654368696C6428746869732E6E6F6465292C746869732E706172656E742E6E6F64652E636C6173734E616D653D746869732E706172656E742E6E6F64652E636C6173734E616D652E7265706C61636528746869732E67657448696465436C6173732829';
wwv_flow_api.g_varchar2_table(489) := '2C2222297D2C642E70726F746F747970652E67657448696465436C6173733D66756E6374696F6E28297B72657475726E20746869735B2250534555444F5F484944455F454C454D454E545F434C4153535F222B28746869732E6265666F72653F22424546';
wwv_flow_api.g_varchar2_table(490) := '4F5245223A22414654455222295D7D2C642E70726F746F747970652E50534555444F5F484944455F454C454D454E545F434C4153535F4245464F52453D225F5F5F68746D6C3263616E7661735F5F5F70736575646F656C656D656E745F6265666F726522';
wwv_flow_api.g_varchar2_table(491) := '2C642E70726F746F747970652E50534555444F5F484944455F454C454D454E545F434C4153535F41465445523D225F5F5F68746D6C3263616E7661735F5F5F70736575646F656C656D656E745F6166746572222C622E6578706F7274733D647D2C7B222E';
wwv_flow_api.g_varchar2_table(492) := '2F6E6F6465636F6E7461696E6572223A31347D5D2C31393A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C622C632C642C65297B746869732E77696474683D612C746869732E6865696768743D622C746869732E696D616765';
wwv_flow_api.g_varchar2_table(493) := '733D632C746869732E6F7074696F6E733D642C746869732E646F63756D656E743D657D76617220653D6128222E2F6C6F6722293B642E70726F746F747970652E72656E646572496D6167653D66756E6374696F6E28612C622C632C64297B76617220653D';
wwv_flow_api.g_varchar2_table(494) := '612E637373496E74282270616464696E674C65667422292C663D612E637373496E74282270616464696E67546F7022292C673D612E637373496E74282270616464696E67526967687422292C683D612E637373496E74282270616464696E67426F74746F';
wwv_flow_api.g_varchar2_table(495) := '6D22292C693D632E626F72646572732C6A3D622E77696474682D28695B315D2E77696474682B695B335D2E77696474682B652B67292C6B3D622E6865696768742D28695B305D2E77696474682B695B325D2E77696474682B662B68293B746869732E6472';
wwv_flow_api.g_varchar2_table(496) := '6177496D61676528642C302C302C642E696D6167652E77696474687C7C6A2C642E696D6167652E6865696768747C7C6B2C622E6C6566742B652B695B335D2E77696474682C622E746F702B662B695B305D2E77696474682C6A2C6B297D2C642E70726F74';
wwv_flow_api.g_varchar2_table(497) := '6F747970652E72656E6465724261636B67726F756E643D66756E6374696F6E28612C622C63297B622E6865696768743E302626622E77696474683E30262628746869732E72656E6465724261636B67726F756E64436F6C6F7228612C62292C746869732E';
wwv_flow_api.g_varchar2_table(498) := '72656E6465724261636B67726F756E64496D61676528612C622C6329297D2C642E70726F746F747970652E72656E6465724261636B67726F756E64436F6C6F723D66756E6374696F6E28612C62297B76617220633D612E636F6C6F7228226261636B6772';
wwv_flow_api.g_varchar2_table(499) := '6F756E64436F6C6F7222293B632E69735472616E73706172656E7428297C7C746869732E72656374616E676C6528622E6C6566742C622E746F702C622E77696474682C622E6865696768742C63297D2C642E70726F746F747970652E72656E646572426F';
wwv_flow_api.g_varchar2_table(500) := '72646572733D66756E6374696F6E2861297B612E666F724561636828746869732E72656E646572426F726465722C74686973297D2C642E70726F746F747970652E72656E646572426F726465723D66756E6374696F6E2861297B612E636F6C6F722E6973';
wwv_flow_api.g_varchar2_table(501) := '5472616E73706172656E7428297C7C6E756C6C3D3D3D612E617267737C7C746869732E64726177536861706528612E617267732C612E636F6C6F72297D2C642E70726F746F747970652E72656E6465724261636B67726F756E64496D6167653D66756E63';
wwv_flow_api.g_varchar2_table(502) := '74696F6E28612C622C63297B76617220643D612E70617273654261636B67726F756E64496D6167657328293B642E7265766572736528292E666F72456163682866756E6374696F6E28642C662C67297B73776974636828642E6D6574686F64297B636173';
wwv_flow_api.g_varchar2_table(503) := '652275726C223A76617220683D746869732E696D616765732E67657428642E617267735B305D293B683F746869732E72656E6465724261636B67726F756E64526570656174696E6728612C622C682C672E6C656E6774682D28662B31292C63293A652822';
wwv_flow_api.g_varchar2_table(504) := '4572726F72206C6F6164696E67206261636B67726F756E642D696D616765222C642E617267735B305D293B627265616B3B63617365226C696E6561722D6772616469656E74223A63617365226772616469656E74223A76617220693D746869732E696D61';
wwv_flow_api.g_varchar2_table(505) := '6765732E67657428642E76616C7565293B693F746869732E72656E6465724261636B67726F756E644772616469656E7428692C622C63293A6528224572726F72206C6F6164696E67206261636B67726F756E642D696D616765222C642E617267735B305D';
wwv_flow_api.g_varchar2_table(506) := '293B627265616B3B63617365226E6F6E65223A627265616B3B64656661756C743A652822556E6B6E6F776E206261636B67726F756E642D696D6167652074797065222C642E617267735B305D297D7D2C74686973297D2C642E70726F746F747970652E72';
wwv_flow_api.g_varchar2_table(507) := '656E6465724261636B67726F756E64526570656174696E673D66756E6374696F6E28612C622C632C642C65297B76617220663D612E70617273654261636B67726F756E6453697A6528622C632E696D6167652C64292C673D612E70617273654261636B67';
wwv_flow_api.g_varchar2_table(508) := '726F756E64506F736974696F6E28622C632E696D6167652C642C66292C683D612E70617273654261636B67726F756E645265706561742864293B7377697463682868297B63617365227265706561742D78223A6361736522726570656174206E6F2D7265';
wwv_flow_api.g_varchar2_table(509) := '70656174223A746869732E6261636B67726F756E64526570656174536861706528632C672C662C622C622E6C6566742B655B335D2C622E746F702B672E746F702B655B305D2C39393939392C662E6865696768742C65293B627265616B3B636173652272';
wwv_flow_api.g_varchar2_table(510) := '65706561742D79223A63617365226E6F2D72657065617420726570656174223A746869732E6261636B67726F756E64526570656174536861706528632C672C662C622C622E6C6566742B672E6C6566742B655B335D2C622E746F702B655B305D2C662E77';
wwv_flow_api.g_varchar2_table(511) := '696474682C39393939392C65293B627265616B3B63617365226E6F2D726570656174223A746869732E6261636B67726F756E64526570656174536861706528632C672C662C622C622E6C6566742B672E6C6566742B655B335D2C622E746F702B672E746F';
wwv_flow_api.g_varchar2_table(512) := '702B655B305D2C662E77696474682C662E6865696768742C65293B627265616B3B64656661756C743A746869732E72656E6465724261636B67726F756E6452657065617428632C672C662C7B746F703A622E746F702C6C6566743A622E6C6566747D2C65';
wwv_flow_api.g_varchar2_table(513) := '5B335D2C655B305D297D7D2C622E6578706F7274733D647D2C7B222E2F6C6F67223A31337D5D2C32303A5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B662E6170706C7928746869732C617267756D656E7473292C74';
wwv_flow_api.g_varchar2_table(514) := '6869732E63616E7661733D746869732E6F7074696F6E732E63616E7661737C7C746869732E646F63756D656E742E637265617465456C656D656E74282263616E76617322292C746869732E6F7074696F6E732E63616E7661737C7C28746869732E63616E';
wwv_flow_api.g_varchar2_table(515) := '7661732E77696474683D612C746869732E63616E7661732E6865696768743D62292C746869732E6374783D746869732E63616E7661732E676574436F6E746578742822326422292C746869732E7461696E744374783D746869732E646F63756D656E742E';
wwv_flow_api.g_varchar2_table(516) := '637265617465456C656D656E74282263616E76617322292E676574436F6E746578742822326422292C746869732E6374782E74657874426173656C696E653D22626F74746F6D222C746869732E7661726961626C65733D7B7D2C682822496E697469616C';
wwv_flow_api.g_varchar2_table(517) := '697A65642043616E76617352656E646572657220776974682073697A65222C612C2278222C62297D66756E6374696F6E20652861297B72657475726E20612E6C656E6774683E307D76617220663D6128222E2E2F72656E646572657222292C673D612822';
wwv_flow_api.g_varchar2_table(518) := '2E2E2F6C696E6561726772616469656E74636F6E7461696E657222292C683D6128222E2E2F6C6F6722293B642E70726F746F747970653D4F626A6563742E63726561746528662E70726F746F74797065292C642E70726F746F747970652E73657446696C';
wwv_flow_api.g_varchar2_table(519) := '6C5374796C653D66756E6374696F6E2861297B72657475726E20746869732E6374782E66696C6C5374796C653D226F626A656374223D3D747970656F6620612626612E6973436F6C6F723F612E746F537472696E6728293A612C746869732E6374787D2C';
wwv_flow_api.g_varchar2_table(520) := '642E70726F746F747970652E72656374616E676C653D66756E6374696F6E28612C622C632C642C65297B746869732E73657446696C6C5374796C652865292E66696C6C5265637428612C622C632C64297D2C642E70726F746F747970652E636972636C65';
wwv_flow_api.g_varchar2_table(521) := '3D66756E6374696F6E28612C622C632C64297B746869732E73657446696C6C5374796C652864292C746869732E6374782E626567696E5061746828292C746869732E6374782E61726328612B632F322C622B632F322C632F322C302C322A4D6174682E50';
wwv_flow_api.g_varchar2_table(522) := '492C2130292C746869732E6374782E636C6F73655061746828292C746869732E6374782E66696C6C28297D2C642E70726F746F747970652E636972636C655374726F6B653D66756E6374696F6E28612C622C632C642C652C66297B746869732E63697263';
wwv_flow_api.g_varchar2_table(523) := '6C6528612C622C632C64292C746869732E6374782E7374726F6B655374796C653D662E746F537472696E6728292C746869732E6374782E7374726F6B6528297D2C642E70726F746F747970652E6472617753686170653D66756E6374696F6E28612C6229';
wwv_flow_api.g_varchar2_table(524) := '7B746869732E73686170652861292C746869732E73657446696C6C5374796C652862292E66696C6C28297D2C642E70726F746F747970652E7461696E74733D66756E6374696F6E2861297B6966286E756C6C3D3D3D612E7461696E746564297B74686973';
wwv_flow_api.g_varchar2_table(525) := '2E7461696E744374782E64726177496D61676528612E696D6167652C302C30293B7472797B746869732E7461696E744374782E676574496D6167654461746128302C302C312C31292C612E7461696E7465643D21317D63617463682862297B746869732E';
wwv_flow_api.g_varchar2_table(526) := '7461696E744374783D646F63756D656E742E637265617465456C656D656E74282263616E76617322292E676574436F6E746578742822326422292C612E7461696E7465643D21307D7D72657475726E20612E7461696E7465647D2C642E70726F746F7479';
wwv_flow_api.g_varchar2_table(527) := '70652E64726177496D6167653D66756E6374696F6E28612C622C632C642C652C662C672C682C69297B2821746869732E7461696E74732861297C7C746869732E6F7074696F6E732E616C6C6F775461696E74292626746869732E6374782E64726177496D';
wwv_flow_api.g_varchar2_table(528) := '61676528612E696D6167652C622C632C642C652C662C672C682C69297D2C642E70726F746F747970652E636C69703D66756E6374696F6E28612C622C63297B746869732E6374782E7361766528292C612E66696C7465722865292E666F72456163682866';
wwv_flow_api.g_varchar2_table(529) := '756E6374696F6E2861297B746869732E73686170652861292E636C697028297D2C74686973292C622E63616C6C2863292C746869732E6374782E726573746F726528297D2C642E70726F746F747970652E73686170653D66756E6374696F6E2861297B72';
wwv_flow_api.g_varchar2_table(530) := '657475726E20746869732E6374782E626567696E5061746828292C612E666F72456163682866756E6374696F6E28612C62297B2272656374223D3D3D615B305D3F746869732E6374782E726563742E6170706C7928746869732E6374782C612E736C6963';
wwv_flow_api.g_varchar2_table(531) := '65283129293A746869732E6374785B303D3D3D623F226D6F7665546F223A615B305D2B22546F225D2E6170706C7928746869732E6374782C612E736C696365283129297D2C74686973292C746869732E6374782E636C6F73655061746828292C74686973';
wwv_flow_api.g_varchar2_table(532) := '2E6374787D2C642E70726F746F747970652E666F6E743D66756E6374696F6E28612C622C632C642C652C66297B746869732E73657446696C6C5374796C652861292E666F6E743D5B622C632C642C652C665D2E6A6F696E28222022292E73706C69742822';
wwv_flow_api.g_varchar2_table(533) := '2C22295B305D7D2C642E70726F746F747970652E666F6E74536861646F773D66756E6374696F6E28612C622C632C64297B746869732E7365745661726961626C652822736861646F77436F6C6F72222C612E746F537472696E672829292E736574566172';
wwv_flow_api.g_varchar2_table(534) := '6961626C652822736861646F774F666673657459222C62292E7365745661726961626C652822736861646F774F666673657458222C63292E7365745661726961626C652822736861646F77426C7572222C64297D2C642E70726F746F747970652E636C65';
wwv_flow_api.g_varchar2_table(535) := '6172536861646F773D66756E6374696F6E28297B746869732E7365745661726961626C652822736861646F77436F6C6F72222C227267626128302C302C302C302922297D2C642E70726F746F747970652E7365744F7061636974793D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(536) := '2861297B746869732E6374782E676C6F62616C416C7068613D617D2C642E70726F746F747970652E7365745472616E73666F726D3D66756E6374696F6E2861297B746869732E6374782E7472616E736C61746528612E6F726967696E5B305D2C612E6F72';
wwv_flow_api.g_varchar2_table(537) := '6967696E5B315D292C746869732E6374782E7472616E73666F726D2E6170706C7928746869732E6374782C612E6D6174726978292C746869732E6374782E7472616E736C617465282D612E6F726967696E5B305D2C2D612E6F726967696E5B315D297D2C';
wwv_flow_api.g_varchar2_table(538) := '642E70726F746F747970652E7365745661726961626C653D66756E6374696F6E28612C62297B72657475726E20746869732E7661726961626C65735B615D213D3D62262628746869732E7661726961626C65735B615D3D746869732E6374785B615D3D62';
wwv_flow_api.g_varchar2_table(539) := '292C746869737D2C642E70726F746F747970652E746578743D66756E6374696F6E28612C622C63297B746869732E6374782E66696C6C5465787428612C622C63297D2C642E70726F746F747970652E6261636B67726F756E645265706561745368617065';
wwv_flow_api.g_varchar2_table(540) := '3D66756E6374696F6E28612C622C632C642C652C662C672C682C69297B766172206A3D5B5B226C696E65222C4D6174682E726F756E642865292C4D6174682E726F756E642866295D2C5B226C696E65222C4D6174682E726F756E6428652B67292C4D6174';
wwv_flow_api.g_varchar2_table(541) := '682E726F756E642866295D2C5B226C696E65222C4D6174682E726F756E6428652B67292C4D6174682E726F756E6428682B66295D2C5B226C696E65222C4D6174682E726F756E642865292C4D6174682E726F756E6428682B66295D5D3B746869732E636C';
wwv_flow_api.g_varchar2_table(542) := '6970285B6A5D2C66756E6374696F6E28297B746869732E72656E6465724261636B67726F756E6452657065617428612C622C632C642C695B335D2C695B305D297D2C74686973297D2C642E70726F746F747970652E72656E6465724261636B67726F756E';
wwv_flow_api.g_varchar2_table(543) := '645265706561743D66756E6374696F6E28612C622C632C642C652C66297B76617220673D4D6174682E726F756E6428642E6C6566742B622E6C6566742B65292C683D4D6174682E726F756E6428642E746F702B622E746F702B66293B746869732E736574';
wwv_flow_api.g_varchar2_table(544) := '46696C6C5374796C6528746869732E6374782E6372656174655061747465726E28746869732E726573697A65496D61676528612C63292C227265706561742229292C746869732E6374782E7472616E736C61746528672C68292C746869732E6374782E66';
wwv_flow_api.g_varchar2_table(545) := '696C6C28292C746869732E6374782E7472616E736C617465282D672C2D68297D2C642E70726F746F747970652E72656E6465724261636B67726F756E644772616469656E743D66756E6374696F6E28612C62297B6966286120696E7374616E63656F6620';
wwv_flow_api.g_varchar2_table(546) := '67297B76617220633D746869732E6374782E6372656174654C696E6561724772616469656E7428622E6C6566742B622E77696474682A612E78302C622E746F702B622E6865696768742A612E79302C622E6C6566742B622E77696474682A612E78312C62';
wwv_flow_api.g_varchar2_table(547) := '2E746F702B622E6865696768742A612E7931293B612E636F6C6F7253746F70732E666F72456163682866756E6374696F6E2861297B632E616464436F6C6F7253746F7028612E73746F702C612E636F6C6F722E746F537472696E672829297D292C746869';
wwv_flow_api.g_varchar2_table(548) := '732E72656374616E676C6528622E6C6566742C622E746F702C622E77696474682C622E6865696768742C63297D7D2C642E70726F746F747970652E726573697A65496D6167653D66756E6374696F6E28612C62297B76617220633D612E696D6167653B69';
wwv_flow_api.g_varchar2_table(549) := '6628632E77696474683D3D3D622E77696474682626632E6865696768743D3D3D622E6865696768742972657475726E20633B76617220642C653D646F63756D656E742E637265617465456C656D656E74282263616E76617322293B72657475726E20652E';
wwv_flow_api.g_varchar2_table(550) := '77696474683D622E77696474682C652E6865696768743D622E6865696768742C643D652E676574436F6E746578742822326422292C642E64726177496D61676528632C302C302C632E77696474682C632E6865696768742C302C302C622E77696474682C';
wwv_flow_api.g_varchar2_table(551) := '622E686569676874292C657D2C622E6578706F7274733D647D2C7B222E2E2F6C696E6561726772616469656E74636F6E7461696E6572223A31322C222E2E2F6C6F67223A31332C222E2E2F72656E6465726572223A31397D5D2C32313A5B66756E637469';
wwv_flow_api.g_varchar2_table(552) := '6F6E28612C622C63297B66756E6374696F6E206428612C622C632C64297B652E63616C6C28746869732C632C64292C746869732E6F776E537461636B696E673D612C746869732E636F6E74657874733D5B5D2C746869732E6368696C6472656E3D5B5D2C';
wwv_flow_api.g_varchar2_table(553) := '746869732E6F7061636974793D28746869732E706172656E743F746869732E706172656E742E737461636B2E6F7061636974793A31292A627D76617220653D6128222E2F6E6F6465636F6E7461696E657222293B642E70726F746F747970653D4F626A65';
wwv_flow_api.g_varchar2_table(554) := '63742E63726561746528652E70726F746F74797065292C642E70726F746F747970652E676574506172656E74537461636B3D66756E6374696F6E2861297B76617220623D746869732E706172656E743F746869732E706172656E742E737461636B3A6E75';
wwv_flow_api.g_varchar2_table(555) := '6C6C3B72657475726E20623F622E6F776E537461636B696E673F623A622E676574506172656E74537461636B2861293A612E737461636B7D2C622E6578706F7274733D647D2C7B222E2F6E6F6465636F6E7461696E6572223A31347D5D2C32323A5B6675';
wwv_flow_api.g_varchar2_table(556) := '6E6374696F6E28612C622C63297B66756E6374696F6E20642861297B746869732E72616E6765426F756E64733D746869732E7465737452616E6765426F756E64732861292C746869732E636F72733D746869732E74657374434F525328292C746869732E';
wwv_flow_api.g_varchar2_table(557) := '7376673D746869732E7465737453564728297D642E70726F746F747970652E7465737452616E6765426F756E64733D66756E6374696F6E2861297B76617220622C632C642C652C663D21313B72657475726E20612E63726561746552616E676526262862';
wwv_flow_api.g_varchar2_table(558) := '3D612E63726561746552616E676528292C622E676574426F756E64696E67436C69656E7452656374262628633D612E637265617465456C656D656E742822626F756E647465737422292C632E7374796C652E6865696768743D223132337078222C632E73';
wwv_flow_api.g_varchar2_table(559) := '74796C652E646973706C61793D22626C6F636B222C612E626F64792E617070656E644368696C642863292C622E73656C6563744E6F64652863292C643D622E676574426F756E64696E67436C69656E745265637428292C653D642E6865696768742C3132';
wwv_flow_api.g_varchar2_table(560) := '333D3D3D65262628663D2130292C612E626F64792E72656D6F76654368696C6428632929292C667D2C642E70726F746F747970652E74657374434F52533D66756E6374696F6E28297B72657475726E22756E646566696E656422213D747970656F66286E';
wwv_flow_api.g_varchar2_table(561) := '657720496D616765292E63726F73734F726967696E7D2C642E70726F746F747970652E746573745356473D66756E6374696F6E28297B76617220613D6E657720496D6167652C623D646F63756D656E742E637265617465456C656D656E74282263616E76';
wwv_flow_api.g_varchar2_table(562) := '617322292C633D622E676574436F6E746578742822326422293B612E7372633D22646174613A696D6167652F7376672B786D6C2C3C73766720786D6C6E733D27687474703A2F2F7777772E77332E6F72672F323030302F737667273E3C2F7376673E223B';
wwv_flow_api.g_varchar2_table(563) := '7472797B632E64726177496D61676528612C302C30292C622E746F4461746155524C28297D63617463682864297B72657475726E21317D72657475726E21307D2C622E6578706F7274733D647D2C7B7D5D2C32333A5B66756E6374696F6E28612C622C63';
wwv_flow_api.g_varchar2_table(564) := '297B66756E6374696F6E20642861297B746869732E7372633D612C746869732E696D6167653D6E756C6C3B76617220623D746869733B746869732E70726F6D6973653D746869732E68617346616272696328292E7468656E2866756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(565) := '72657475726E20622E6973496E6C696E652861293F50726F6D6973652E7265736F6C766528622E696E6C696E65466F726D617474696E67286129293A652861297D292E7468656E2866756E6374696F6E2861297B72657475726E206E65772050726F6D69';
wwv_flow_api.g_varchar2_table(566) := '73652866756E6374696F6E2863297B77696E646F772E68746D6C3263616E7661732E7376672E6661627269632E6C6F616453564746726F6D537472696E6728612C622E63726561746543616E7661732E63616C6C28622C6329297D297D297D7661722065';
wwv_flow_api.g_varchar2_table(567) := '3D6128222E2F78687222292C663D6128222E2F7574696C7322292E6465636F646536343B642E70726F746F747970652E6861734661627269633D66756E6374696F6E28297B72657475726E2077696E646F772E68746D6C3263616E7661732E7376672626';
wwv_flow_api.g_varchar2_table(568) := '77696E646F772E68746D6C3263616E7661732E7376672E6661627269633F50726F6D6973652E7265736F6C766528293A50726F6D6973652E72656A656374286E6577204572726F72282268746D6C3263616E7661732E7376672E6A73206973206E6F7420';
wwv_flow_api.g_varchar2_table(569) := '6C6F616465642C2063616E6E6F742072656E646572207376672229297D2C642E70726F746F747970652E696E6C696E65466F726D617474696E673D66756E6374696F6E2861297B72657475726E2F5E646174613A696D6167655C2F7376675C2B786D6C3B';
wwv_flow_api.g_varchar2_table(570) := '6261736536342C2F2E746573742861293F746869732E6465636F6465363428746869732E72656D6F7665436F6E74656E7454797065286129293A746869732E72656D6F7665436F6E74656E74547970652861297D2C642E70726F746F747970652E72656D';
wwv_flow_api.g_varchar2_table(571) := '6F7665436F6E74656E74547970653D66756E6374696F6E2861297B72657475726E20612E7265706C616365282F5E646174613A696D6167655C2F7376675C2B786D6C283B626173653634293F2C2F2C2222297D2C642E70726F746F747970652E6973496E';
wwv_flow_api.g_varchar2_table(572) := '6C696E653D66756E6374696F6E2861297B72657475726E2F5E646174613A696D6167655C2F7376675C2B786D6C2F692E746573742861297D2C642E70726F746F747970652E63726561746543616E7661733D66756E6374696F6E2861297B76617220623D';
wwv_flow_api.g_varchar2_table(573) := '746869733B72657475726E2066756E6374696F6E28632C64297B76617220653D6E65772077696E646F772E68746D6C3263616E7661732E7376672E6661627269632E53746174696343616E76617328226322293B622E696D6167653D652E6C6F77657243';
wwv_flow_api.g_varchar2_table(574) := '616E766173456C2C652E736574576964746828642E7769647468292E73657448656967687428642E686569676874292E6164642877696E646F772E68746D6C3263616E7661732E7376672E6661627269632E7574696C2E67726F7570535647456C656D65';
wwv_flow_api.g_varchar2_table(575) := '6E747328632C6429292E72656E646572416C6C28292C6128652E6C6F77657243616E766173456C297D7D2C642E70726F746F747970652E6465636F646536343D66756E6374696F6E2861297B72657475726E2266756E6374696F6E223D3D747970656F66';
wwv_flow_api.g_varchar2_table(576) := '2077696E646F772E61746F623F77696E646F772E61746F622861293A662861297D2C622E6578706F7274733D647D2C7B222E2F7574696C73223A32362C222E2F786872223A32387D5D2C32343A5B66756E6374696F6E28612C622C63297B66756E637469';
wwv_flow_api.g_varchar2_table(577) := '6F6E206428612C62297B746869732E7372633D612C746869732E696D6167653D6E756C6C3B76617220633D746869733B746869732E70726F6D6973653D623F6E65772050726F6D6973652866756E6374696F6E28622C64297B632E696D6167653D6E6577';
wwv_flow_api.g_varchar2_table(578) := '20496D6167652C632E696D6167652E6F6E6C6F61643D622C632E696D6167652E6F6E6572726F723D642C632E696D6167652E7372633D22646174613A696D6167652F7376672B786D6C2C222B286E657720584D4C53657269616C697A6572292E73657269';
wwv_flow_api.g_varchar2_table(579) := '616C697A65546F537472696E672861292C632E696D6167652E636F6D706C6574653D3D3D213026266228632E696D616765297D293A746869732E68617346616272696328292E7468656E2866756E6374696F6E28297B72657475726E206E65772050726F';
wwv_flow_api.g_varchar2_table(580) := '6D6973652866756E6374696F6E2862297B77696E646F772E68746D6C3263616E7661732E7376672E6661627269632E7061727365535647446F63756D656E7428612C632E63726561746543616E7661732E63616C6C28632C6229297D297D297D76617220';
wwv_flow_api.g_varchar2_table(581) := '653D6128222E2F737667636F6E7461696E657222293B642E70726F746F747970653D4F626A6563742E63726561746528652E70726F746F74797065292C622E6578706F7274733D647D2C7B222E2F737667636F6E7461696E6572223A32337D5D2C32353A';
wwv_flow_api.g_varchar2_table(582) := '5B66756E6374696F6E28612C622C63297B66756E6374696F6E206428612C62297B662E63616C6C28746869732C612C62297D66756E6374696F6E206528612C622C63297B72657475726E20612E6C656E6774683E303F622B632E746F5570706572436173';
wwv_flow_api.g_varchar2_table(583) := '6528293A766F696420307D76617220663D6128222E2F6E6F6465636F6E7461696E657222293B642E70726F746F747970653D4F626A6563742E63726561746528662E70726F746F74797065292C642E70726F746F747970652E6170706C79546578745472';
wwv_flow_api.g_varchar2_table(584) := '616E73666F726D3D66756E6374696F6E28297B746869732E6E6F64652E646174613D746869732E7472616E73666F726D28746869732E706172656E742E6373732822746578745472616E73666F726D2229297D2C642E70726F746F747970652E7472616E';
wwv_flow_api.g_varchar2_table(585) := '73666F726D3D66756E6374696F6E2861297B76617220623D746869732E6E6F64652E646174613B7377697463682861297B63617365226C6F77657263617365223A72657475726E20622E746F4C6F7765724361736528293B63617365226361706974616C';
wwv_flow_api.g_varchar2_table(586) := '697A65223A72657475726E20622E7265706C616365282F285E7C5C737C3A7C2D7C5C287C5C2929285B612D7A5D292F672C65293B6361736522757070657263617365223A72657475726E20622E746F55707065724361736528293B64656661756C743A72';
wwv_flow_api.g_varchar2_table(587) := '657475726E20627D7D2C622E6578706F7274733D647D2C7B222E2F6E6F6465636F6E7461696E6572223A31347D5D2C32363A5B66756E6374696F6E28612C622C63297B632E736D616C6C496D6167653D66756E6374696F6E28297B72657475726E226461';
wwv_flow_api.g_varchar2_table(588) := '74613A696D6167652F6769663B6261736536342C52306C474F446C6841514142414941414141414141502F2F2F79483542414541414141414C41414141414142414145414141494252414137227D2C632E62696E643D66756E6374696F6E28612C62297B';
wwv_flow_api.g_varchar2_table(589) := '72657475726E2066756E6374696F6E28297B72657475726E20612E6170706C7928622C617267756D656E7473297D7D2C632E6465636F646536343D66756E6374696F6E2861297B76617220622C632C642C652C662C672C682C692C6A3D22414243444546';
wwv_flow_api.g_varchar2_table(590) := '4748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F222C6B3D612E6C656E6774682C6C3D22223B666F7228623D303B6B3E623B622B3D3429633D6A2E696E64';
wwv_flow_api.g_varchar2_table(591) := '65784F6628615B625D292C643D6A2E696E6465784F6628615B622B315D292C653D6A2E696E6465784F6628615B622B325D292C663D6A2E696E6465784F6628615B622B335D292C673D633C3C327C643E3E342C683D2831352664293C3C347C653E3E322C';
wwv_flow_api.g_varchar2_table(592) := '693D28332665293C3C367C662C6C2B3D36343D3D3D653F537472696E672E66726F6D43686172436F64652867293A36343D3D3D667C7C2D313D3D3D663F537472696E672E66726F6D43686172436F646528672C68293A537472696E672E66726F6D436861';
wwv_flow_api.g_varchar2_table(593) := '72436F646528672C682C69293B72657475726E206C7D2C632E676574426F756E64733D66756E6374696F6E2861297B696628612E676574426F756E64696E67436C69656E7452656374297B76617220623D612E676574426F756E64696E67436C69656E74';
wwv_flow_api.g_varchar2_table(594) := '5265637428292C633D6E756C6C3D3D612E6F666673657457696474683F622E77696474683A612E6F666673657457696474683B72657475726E7B746F703A622E746F702C626F74746F6D3A622E626F74746F6D7C7C622E746F702B622E6865696768742C';
wwv_flow_api.g_varchar2_table(595) := '72696768743A622E6C6566742B632C6C6566743A622E6C6566742C77696474683A632C6865696768743A6E756C6C3D3D612E6F66667365744865696768743F622E6865696768743A612E6F66667365744865696768747D7D72657475726E7B7D7D2C632E';
wwv_flow_api.g_varchar2_table(596) := '6F6666736574426F756E64733D66756E6374696F6E2861297B76617220623D612E6F6666736574506172656E743F632E6F6666736574426F756E647328612E6F6666736574506172656E74293A7B746F703A302C6C6566743A307D3B72657475726E7B74';
wwv_flow_api.g_varchar2_table(597) := '6F703A612E6F6666736574546F702B622E746F702C626F74746F6D3A612E6F6666736574546F702B612E6F66667365744865696768742B622E746F702C72696768743A612E6F66667365744C6566742B622E6C6566742B612E6F66667365745769647468';
wwv_flow_api.g_varchar2_table(598) := '2C6C6566743A612E6F66667365744C6566742B622E6C6566742C77696474683A612E6F666673657457696474682C6865696768743A612E6F66667365744865696768747D7D2C632E70617273654261636B67726F756E64733D66756E6374696F6E286129';
wwv_flow_api.g_varchar2_table(599) := '7B76617220622C632C642C652C662C672C682C693D22205C725C6E09222C6A3D5B5D2C6B3D302C6C3D302C6D3D66756E6374696F6E28297B622626282722273D3D3D632E73756273747228302C3129262628633D632E73756273747228312C632E6C656E';
wwv_flow_api.g_varchar2_table(600) := '6774682D3229292C632626682E707573682863292C222D223D3D3D622E73756273747228302C3129262628653D622E696E6465784F6628222D222C31292B31293E30262628643D622E73756273747228302C65292C623D622E737562737472286529292C';
wwv_flow_api.g_varchar2_table(601) := '6A2E70757368287B7072656669783A642C6D6574686F643A622E746F4C6F7765724361736528292C76616C75653A662C617267733A682C696D6167653A6E756C6C7D29292C683D5B5D2C623D643D633D663D22227D3B72657475726E20683D5B5D2C623D';
wwv_flow_api.g_varchar2_table(602) := '643D633D663D22222C612E73706C6974282222292E666F72456163682866756E6374696F6E2861297B6966282128303D3D3D6B2626692E696E6465784F662861293E2D3129297B7377697463682861297B636173652722273A673F673D3D3D6126262867';
wwv_flow_api.g_varchar2_table(603) := '3D6E756C6C293A673D613B627265616B3B636173652228223A6966286729627265616B3B696628303D3D3D6B2972657475726E206B3D312C766F696428662B3D61293B6C2B2B3B627265616B3B636173652229223A6966286729627265616B3B69662831';
wwv_flow_api.g_varchar2_table(604) := '3D3D3D6B297B696628303D3D3D6C2972657475726E206B3D302C662B3D612C766F6964206D28293B6C2D2D7D627265616B3B63617365222C223A6966286729627265616B3B696628303D3D3D6B2972657475726E20766F6964206D28293B696628313D3D';
wwv_flow_api.g_varchar2_table(605) := '3D6B2626303D3D3D6C262621622E6D61746368282F5E75726C242F69292972657475726E20682E707573682863292C633D22222C766F696428662B3D61297D662B3D612C303D3D3D6B3F622B3D613A632B3D617D7D292C6D28292C6A7D7D2C7B7D5D2C32';
wwv_flow_api.g_varchar2_table(606) := '373A5B66756E6374696F6E28612C622C63297B66756E6374696F6E20642861297B652E6170706C7928746869732C617267756D656E7473292C746869732E747970653D226C696E656172223D3D3D612E617267735B305D3F652E54595045532E4C494E45';
wwv_flow_api.g_varchar2_table(607) := '41523A652E54595045532E52414449414C7D76617220653D6128222E2F6772616469656E74636F6E7461696E657222293B642E70726F746F747970653D4F626A6563742E63726561746528652E70726F746F74797065292C622E6578706F7274733D647D';
wwv_flow_api.g_varchar2_table(608) := '2C7B222E2F6772616469656E74636F6E7461696E6572223A397D5D2C32383A5B66756E6374696F6E28612C622C63297B66756E6374696F6E20642861297B72657475726E206E65772050726F6D6973652866756E6374696F6E28622C63297B7661722064';
wwv_flow_api.g_varchar2_table(609) := '3D6E657720584D4C48747470526571756573743B642E6F70656E2822474554222C61292C642E6F6E6C6F61643D66756E6374696F6E28297B3230303D3D3D642E7374617475733F6228642E726573706F6E736554657874293A63286E6577204572726F72';
wwv_flow_api.g_varchar2_table(610) := '28642E7374617475735465787429297D2C642E6F6E6572726F723D66756E6374696F6E28297B63286E6577204572726F7228224E6574776F726B204572726F722229297D2C642E73656E6428297D297D622E6578706F7274733D647D2C7B7D5D7D2C7B7D';
wwv_flow_api.g_varchar2_table(611) := '2C5B345D292834297D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(20921769528361028472)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_file_name=>'html2canvas.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A210A202A20406F76657276696577206573362D70726F6D697365202D20612074696E7920696D706C656D656E746174696F6E206F662050726F6D697365732F412B2E0A202A2040636F7079726967687420436F707972696768742028632920323031';
wwv_flow_api.g_varchar2_table(2) := '3420596568756461204B61747A2C20546F6D2044616C652C2053746566616E2050656E6E657220616E6420636F6E7472696275746F72732028436F6E76657273696F6E20746F2045533620415049206279204A616B6520417263686962616C64290A202A';
wwv_flow_api.g_varchar2_table(3) := '20406C6963656E73652020204C6963656E73656420756E646572204D4954206C6963656E73650A202A2020202020202020202020205365652068747470733A2F2F7261772E67697468756275736572636F6E74656E742E636F6D2F6A616B656172636869';
wwv_flow_api.g_varchar2_table(4) := '62616C642F6573362D70726F6D6973652F6D61737465722F4C4943454E53450A202A204076657273696F6E202020332E302E320A202A2F0A0A2866756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E206C6962246573362470';
wwv_flow_api.g_varchar2_table(5) := '726F6D697365247574696C7324246F626A6563744F7246756E6374696F6E2878297B72657475726E20747970656F6620783D3D3D2266756E6374696F6E227C7C747970656F6620783D3D3D226F626A65637422262678213D3D6E756C6C7D66756E637469';
wwv_flow_api.g_varchar2_table(6) := '6F6E206C6962246573362470726F6D697365247574696C732424697346756E6374696F6E2878297B72657475726E20747970656F6620783D3D3D2266756E6374696F6E227D66756E6374696F6E206C6962246573362470726F6D697365247574696C7324';
wwv_flow_api.g_varchar2_table(7) := '2469734D617962655468656E61626C652878297B72657475726E20747970656F6620783D3D3D226F626A65637422262678213D3D6E756C6C7D766172206C6962246573362470726F6D697365247574696C7324245F697341727261793B69662821417272';
wwv_flow_api.g_varchar2_table(8) := '61792E69734172726179297B6C6962246573362470726F6D697365247574696C7324245F697341727261793D66756E6374696F6E2878297B72657475726E204F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2878293D3D3D22';
wwv_flow_api.g_varchar2_table(9) := '5B6F626A6563742041727261795D227D7D656C73657B6C6962246573362470726F6D697365247574696C7324245F697341727261793D41727261792E697341727261797D766172206C6962246573362470726F6D697365247574696C7324246973417272';
wwv_flow_api.g_varchar2_table(10) := '61793D6C6962246573362470726F6D697365247574696C7324245F697341727261793B766172206C6962246573362470726F6D697365246173617024246C656E3D303B766172206C6962246573362470726F6D69736524617361702424746F537472696E';
wwv_flow_api.g_varchar2_table(11) := '673D7B7D2E746F537472696E673B766172206C6962246573362470726F6D6973652461736170242476657274784E6578743B766172206C6962246573362470726F6D69736524617361702424637573746F6D5363686564756C6572466E3B766172206C69';
wwv_flow_api.g_varchar2_table(12) := '62246573362470726F6D69736524617361702424617361703D66756E6374696F6E20617361702863616C6C6261636B2C617267297B6C6962246573362470726F6D6973652461736170242471756575655B6C6962246573362470726F6D69736524617361';
wwv_flow_api.g_varchar2_table(13) := '7024246C656E5D3D63616C6C6261636B3B6C6962246573362470726F6D6973652461736170242471756575655B6C6962246573362470726F6D697365246173617024246C656E2B315D3D6172673B6C6962246573362470726F6D69736524617361702424';
wwv_flow_api.g_varchar2_table(14) := '6C656E2B3D323B6966286C6962246573362470726F6D697365246173617024246C656E3D3D3D32297B6966286C6962246573362470726F6D69736524617361702424637573746F6D5363686564756C6572466E297B6C6962246573362470726F6D697365';
wwv_flow_api.g_varchar2_table(15) := '24617361702424637573746F6D5363686564756C6572466E286C6962246573362470726F6D69736524617361702424666C757368297D656C73657B6C6962246573362470726F6D697365246173617024247363686564756C65466C75736828297D7D7D3B';
wwv_flow_api.g_varchar2_table(16) := '66756E6374696F6E206C6962246573362470726F6D697365246173617024247365745363686564756C6572287363686564756C65466E297B6C6962246573362470726F6D69736524617361702424637573746F6D5363686564756C6572466E3D73636865';
wwv_flow_api.g_varchar2_table(17) := '64756C65466E7D66756E6374696F6E206C6962246573362470726F6D69736524617361702424736574417361702861736170466E297B6C6962246573362470726F6D69736524617361702424617361703D61736170466E7D766172206C69622465733624';
wwv_flow_api.g_varchar2_table(18) := '70726F6D6973652461736170242462726F7773657257696E646F773D747970656F662077696E646F77213D3D22756E646566696E6564223F77696E646F773A756E646566696E65643B766172206C6962246573362470726F6D6973652461736170242462';
wwv_flow_api.g_varchar2_table(19) := '726F77736572476C6F62616C3D6C6962246573362470726F6D6973652461736170242462726F7773657257696E646F777C7C7B7D3B766172206C6962246573362470726F6D6973652461736170242442726F777365724D75746174696F6E4F6273657276';
wwv_flow_api.g_varchar2_table(20) := '65723D6C6962246573362470726F6D6973652461736170242462726F77736572476C6F62616C2E4D75746174696F6E4F627365727665727C7C6C6962246573362470726F6D6973652461736170242462726F77736572476C6F62616C2E5765624B69744D';
wwv_flow_api.g_varchar2_table(21) := '75746174696F6E4F627365727665723B766172206C6962246573362470726F6D6973652461736170242469734E6F64653D747970656F662070726F63657373213D3D22756E646566696E65642226267B7D2E746F537472696E672E63616C6C2870726F63';
wwv_flow_api.g_varchar2_table(22) := '657373293D3D3D225B6F626A6563742070726F636573735D223B766172206C6962246573362470726F6D697365246173617024246973576F726B65723D747970656F662055696E7438436C616D7065644172726179213D3D22756E646566696E65642226';
wwv_flow_api.g_varchar2_table(23) := '26747970656F6620696D706F727453637269707473213D3D22756E646566696E6564222626747970656F66204D6573736167654368616E6E656C213D3D22756E646566696E6564223B66756E6374696F6E206C6962246573362470726F6D697365246173';
wwv_flow_api.g_varchar2_table(24) := '617024247573654E6578745469636B28297B72657475726E2066756E6374696F6E28297B70726F636573732E6E6578745469636B286C6962246573362470726F6D69736524617361702424666C757368297D7D66756E6374696F6E206C69622465733624';
wwv_flow_api.g_varchar2_table(25) := '70726F6D69736524617361702424757365566572747854696D657228297B72657475726E2066756E6374696F6E28297B6C6962246573362470726F6D6973652461736170242476657274784E657874286C6962246573362470726F6D6973652461736170';
wwv_flow_api.g_varchar2_table(26) := '2424666C757368297D7D66756E6374696F6E206C6962246573362470726F6D697365246173617024247573654D75746174696F6E4F6273657276657228297B76617220697465726174696F6E733D303B766172206F627365727665723D6E6577206C6962';
wwv_flow_api.g_varchar2_table(27) := '246573362470726F6D6973652461736170242442726F777365724D75746174696F6E4F62736572766572286C6962246573362470726F6D69736524617361702424666C757368293B766172206E6F64653D646F63756D656E742E63726561746554657874';
wwv_flow_api.g_varchar2_table(28) := '4E6F6465282222293B6F627365727665722E6F627365727665286E6F64652C7B636861726163746572446174613A747275657D293B72657475726E2066756E6374696F6E28297B6E6F64652E646174613D697465726174696F6E733D2B2B697465726174';
wwv_flow_api.g_varchar2_table(29) := '696F6E7325327D7D66756E6374696F6E206C6962246573362470726F6D697365246173617024247573654D6573736167654368616E6E656C28297B766172206368616E6E656C3D6E6577204D6573736167654368616E6E656C3B6368616E6E656C2E706F';
wwv_flow_api.g_varchar2_table(30) := '7274312E6F6E6D6573736167653D6C6962246573362470726F6D69736524617361702424666C7573683B72657475726E2066756E6374696F6E28297B6368616E6E656C2E706F7274322E706F73744D6573736167652830297D7D66756E6374696F6E206C';
wwv_flow_api.g_varchar2_table(31) := '6962246573362470726F6D6973652461736170242475736553657454696D656F757428297B72657475726E2066756E6374696F6E28297B73657454696D656F7574286C6962246573362470726F6D69736524617361702424666C7573682C31297D7D7661';
wwv_flow_api.g_varchar2_table(32) := '72206C6962246573362470726F6D6973652461736170242471756575653D6E657720417272617928316533293B66756E6374696F6E206C6962246573362470726F6D69736524617361702424666C75736828297B666F722876617220693D303B693C6C69';
wwv_flow_api.g_varchar2_table(33) := '62246573362470726F6D697365246173617024246C656E3B692B3D32297B7661722063616C6C6261636B3D6C6962246573362470726F6D6973652461736170242471756575655B695D3B766172206172673D6C6962246573362470726F6D697365246173';
wwv_flow_api.g_varchar2_table(34) := '6170242471756575655B692B315D3B63616C6C6261636B28617267293B6C6962246573362470726F6D6973652461736170242471756575655B695D3D756E646566696E65643B6C6962246573362470726F6D6973652461736170242471756575655B692B';
wwv_flow_api.g_varchar2_table(35) := '315D3D756E646566696E65647D6C6962246573362470726F6D697365246173617024246C656E3D307D66756E6374696F6E206C6962246573362470726F6D69736524617361702424617474656D7074566572747828297B7472797B76617220723D726571';
wwv_flow_api.g_varchar2_table(36) := '756972653B7661722076657274783D722822766572747822293B6C6962246573362470726F6D6973652461736170242476657274784E6578743D76657274782E72756E4F6E4C6F6F707C7C76657274782E72756E4F6E436F6E746578743B72657475726E';
wwv_flow_api.g_varchar2_table(37) := '206C6962246573362470726F6D69736524617361702424757365566572747854696D657228297D63617463682865297B72657475726E206C6962246573362470726F6D6973652461736170242475736553657454696D656F757428297D7D766172206C69';
wwv_flow_api.g_varchar2_table(38) := '62246573362470726F6D697365246173617024247363686564756C65466C7573683B6966286C6962246573362470726F6D6973652461736170242469734E6F6465297B6C6962246573362470726F6D697365246173617024247363686564756C65466C75';
wwv_flow_api.g_varchar2_table(39) := '73683D6C6962246573362470726F6D697365246173617024247573654E6578745469636B28297D656C7365206966286C6962246573362470726F6D6973652461736170242442726F777365724D75746174696F6E4F62736572766572297B6C6962246573';
wwv_flow_api.g_varchar2_table(40) := '362470726F6D697365246173617024247363686564756C65466C7573683D6C6962246573362470726F6D697365246173617024247573654D75746174696F6E4F6273657276657228297D656C7365206966286C6962246573362470726F6D697365246173';
wwv_flow_api.g_varchar2_table(41) := '617024246973576F726B6572297B6C6962246573362470726F6D697365246173617024247363686564756C65466C7573683D6C6962246573362470726F6D697365246173617024247573654D6573736167654368616E6E656C28297D656C736520696628';
wwv_flow_api.g_varchar2_table(42) := '6C6962246573362470726F6D6973652461736170242462726F7773657257696E646F773D3D3D756E646566696E65642626747970656F6620726571756972653D3D3D2266756E6374696F6E22297B6C6962246573362470726F6D69736524617361702424';
wwv_flow_api.g_varchar2_table(43) := '7363686564756C65466C7573683D6C6962246573362470726F6D69736524617361702424617474656D7074566572747828297D656C73657B6C6962246573362470726F6D697365246173617024247363686564756C65466C7573683D6C69622465733624';
wwv_flow_api.g_varchar2_table(44) := '70726F6D6973652461736170242475736553657454696D656F757428297D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24246E6F6F7028297B7D766172206C6962246573362470726F6D6973652424696E746572';
wwv_flow_api.g_varchar2_table(45) := '6E616C242450454E44494E473D766F696420303B766172206C6962246573362470726F6D6973652424696E7465726E616C242446554C46494C4C45443D313B766172206C6962246573362470726F6D6973652424696E7465726E616C242452454A454354';
wwv_flow_api.g_varchar2_table(46) := '45443D323B766172206C6962246573362470726F6D6973652424696E7465726E616C24244745545F5448454E5F4552524F523D6E6577206C6962246573362470726F6D6973652424696E7465726E616C24244572726F724F626A6563743B66756E637469';
wwv_flow_api.g_varchar2_table(47) := '6F6E206C6962246573362470726F6D6973652424696E7465726E616C242473656C6646756C66696C6C6D656E7428297B72657475726E206E657720547970654572726F722822596F752063616E6E6F74207265736F6C766520612070726F6D6973652077';
wwv_flow_api.g_varchar2_table(48) := '69746820697473656C6622297D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242463616E6E6F7452657475726E4F776E28297B72657475726E206E657720547970654572726F722822412070726F6D6973657320';
wwv_flow_api.g_varchar2_table(49) := '63616C6C6261636B2063616E6E6F742072657475726E20746861742073616D652070726F6D6973652E22297D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24246765745468656E2870726F6D697365297B747279';
wwv_flow_api.g_varchar2_table(50) := '7B72657475726E2070726F6D6973652E7468656E7D6361746368286572726F72297B6C6962246573362470726F6D6973652424696E7465726E616C24244745545F5448454E5F4552524F522E6572726F723D6572726F723B72657475726E206C69622465';
wwv_flow_api.g_varchar2_table(51) := '73362470726F6D6973652424696E7465726E616C24244745545F5448454E5F4552524F527D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24247472795468656E287468656E2C76616C75652C66756C66696C6C';
wwv_flow_api.g_varchar2_table(52) := '6D656E7448616E646C65722C72656A656374696F6E48616E646C6572297B7472797B7468656E2E63616C6C2876616C75652C66756C66696C6C6D656E7448616E646C65722C72656A656374696F6E48616E646C6572297D63617463682865297B72657475';
wwv_flow_api.g_varchar2_table(53) := '726E20657D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242468616E646C65466F726569676E5468656E61626C652870726F6D6973652C7468656E61626C652C7468656E297B6C6962246573362470726F6D69';
wwv_flow_api.g_varchar2_table(54) := '736524617361702424617361702866756E6374696F6E2870726F6D697365297B766172207365616C65643D66616C73653B766172206572726F723D6C6962246573362470726F6D6973652424696E7465726E616C24247472795468656E287468656E2C74';
wwv_flow_api.g_varchar2_table(55) := '68656E61626C652C66756E6374696F6E2876616C7565297B6966287365616C6564297B72657475726E7D7365616C65643D747275653B6966287468656E61626C65213D3D76616C7565297B6C6962246573362470726F6D6973652424696E7465726E616C';
wwv_flow_api.g_varchar2_table(56) := '24247265736F6C76652870726F6D6973652C76616C7565297D656C73657B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C2870726F6D6973652C76616C7565297D7D2C66756E6374696F6E28726561736F6E297B69';
wwv_flow_api.g_varchar2_table(57) := '66287365616C6564297B72657475726E7D7365616C65643D747275653B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C726561736F6E297D2C22536574746C653A20222B2870726F6D6973652E';
wwv_flow_api.g_varchar2_table(58) := '5F6C6162656C7C7C2220756E6B6E6F776E2070726F6D6973652229293B696628217365616C656426266572726F72297B7365616C65643D747275653B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973';
wwv_flow_api.g_varchar2_table(59) := '652C6572726F72297D7D2C70726F6D697365297D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242468616E646C654F776E5468656E61626C652870726F6D6973652C7468656E61626C65297B6966287468656E61';
wwv_flow_api.g_varchar2_table(60) := '626C652E5F73746174653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242446554C46494C4C4544297B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C2870726F6D6973652C7468656E6162';
wwv_flow_api.g_varchar2_table(61) := '6C652E5F726573756C74297D656C7365206966287468656E61626C652E5F73746174653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242452454A4543544544297B6C6962246573362470726F6D6973652424696E7465726E616C';
wwv_flow_api.g_varchar2_table(62) := '242472656A6563742870726F6D6973652C7468656E61626C652E5F726573756C74297D656C73657B6C6962246573362470726F6D6973652424696E7465726E616C2424737562736372696265287468656E61626C652C756E646566696E65642C66756E63';
wwv_flow_api.g_varchar2_table(63) := '74696F6E2876616C7565297B6C6962246573362470726F6D6973652424696E7465726E616C24247265736F6C76652870726F6D6973652C76616C7565297D2C66756E6374696F6E28726561736F6E297B6C6962246573362470726F6D6973652424696E74';
wwv_flow_api.g_varchar2_table(64) := '65726E616C242472656A6563742870726F6D6973652C726561736F6E297D297D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242468616E646C654D617962655468656E61626C652870726F6D6973652C6D6179';
wwv_flow_api.g_varchar2_table(65) := '62655468656E61626C65297B6966286D617962655468656E61626C652E636F6E7374727563746F723D3D3D70726F6D6973652E636F6E7374727563746F72297B6C6962246573362470726F6D6973652424696E7465726E616C242468616E646C654F776E';
wwv_flow_api.g_varchar2_table(66) := '5468656E61626C652870726F6D6973652C6D617962655468656E61626C65297D656C73657B766172207468656E3D6C6962246573362470726F6D6973652424696E7465726E616C24246765745468656E286D617962655468656E61626C65293B69662874';
wwv_flow_api.g_varchar2_table(67) := '68656E3D3D3D6C6962246573362470726F6D6973652424696E7465726E616C24244745545F5448454E5F4552524F52297B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C6C6962246573362470';
wwv_flow_api.g_varchar2_table(68) := '726F6D6973652424696E7465726E616C24244745545F5448454E5F4552524F522E6572726F72297D656C7365206966287468656E3D3D3D756E646566696E6564297B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C';
wwv_flow_api.g_varchar2_table(69) := '2870726F6D6973652C6D617962655468656E61626C65297D656C7365206966286C6962246573362470726F6D697365247574696C732424697346756E6374696F6E287468656E29297B6C6962246573362470726F6D6973652424696E7465726E616C2424';
wwv_flow_api.g_varchar2_table(70) := '68616E646C65466F726569676E5468656E61626C652870726F6D6973652C6D617962655468656E61626C652C7468656E297D656C73657B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C2870726F6D6973652C6D61';
wwv_flow_api.g_varchar2_table(71) := '7962655468656E61626C65297D7D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24247265736F6C76652870726F6D6973652C76616C7565297B69662870726F6D6973653D3D3D76616C7565297B6C6962246573';
wwv_flow_api.g_varchar2_table(72) := '362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C6C6962246573362470726F6D6973652424696E7465726E616C242473656C6646756C66696C6C6D656E742829297D656C7365206966286C696224657336247072';
wwv_flow_api.g_varchar2_table(73) := '6F6D697365247574696C7324246F626A6563744F7246756E6374696F6E2876616C756529297B6C6962246573362470726F6D6973652424696E7465726E616C242468616E646C654D617962655468656E61626C652870726F6D6973652C76616C7565297D';
wwv_flow_api.g_varchar2_table(74) := '656C73657B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C2870726F6D6973652C76616C7565297D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24247075626C69736852';
wwv_flow_api.g_varchar2_table(75) := '656A656374696F6E2870726F6D697365297B69662870726F6D6973652E5F6F6E6572726F72297B70726F6D6973652E5F6F6E6572726F722870726F6D6973652E5F726573756C74297D6C6962246573362470726F6D6973652424696E7465726E616C2424';
wwv_flow_api.g_varchar2_table(76) := '7075626C6973682870726F6D697365297D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C2870726F6D6973652C76616C7565297B69662870726F6D6973652E5F7374617465213D3D6C696224';
wwv_flow_api.g_varchar2_table(77) := '6573362470726F6D6973652424696E7465726E616C242450454E44494E47297B72657475726E7D70726F6D6973652E5F726573756C743D76616C75653B70726F6D6973652E5F73746174653D6C6962246573362470726F6D6973652424696E7465726E61';
wwv_flow_api.g_varchar2_table(78) := '6C242446554C46494C4C45443B69662870726F6D6973652E5F73756273637269626572732E6C656E677468213D3D30297B6C6962246573362470726F6D6973652461736170242461736170286C6962246573362470726F6D6973652424696E7465726E61';
wwv_flow_api.g_varchar2_table(79) := '6C24247075626C6973682C70726F6D697365297D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C726561736F6E297B69662870726F6D6973652E5F7374617465213D3D';
wwv_flow_api.g_varchar2_table(80) := '6C6962246573362470726F6D6973652424696E7465726E616C242450454E44494E47297B72657475726E7D70726F6D6973652E5F73746174653D6C6962246573362470726F6D6973652424696E7465726E616C242452454A45435445443B70726F6D6973';
wwv_flow_api.g_varchar2_table(81) := '652E5F726573756C743D726561736F6E3B6C6962246573362470726F6D6973652461736170242461736170286C6962246573362470726F6D6973652424696E7465726E616C24247075626C69736852656A656374696F6E2C70726F6D697365297D66756E';
wwv_flow_api.g_varchar2_table(82) := '6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242473756273637269626528706172656E742C6368696C642C6F6E46756C66696C6C6D656E742C6F6E52656A656374696F6E297B7661722073756273637269626572733D70';
wwv_flow_api.g_varchar2_table(83) := '6172656E742E5F73756273637269626572733B766172206C656E6774683D73756273637269626572732E6C656E6774683B706172656E742E5F6F6E6572726F723D6E756C6C3B73756273637269626572735B6C656E6774685D3D6368696C643B73756273';
wwv_flow_api.g_varchar2_table(84) := '637269626572735B6C656E6774682B6C6962246573362470726F6D6973652424696E7465726E616C242446554C46494C4C45445D3D6F6E46756C66696C6C6D656E743B73756273637269626572735B6C656E6774682B6C6962246573362470726F6D6973';
wwv_flow_api.g_varchar2_table(85) := '652424696E7465726E616C242452454A45435445445D3D6F6E52656A656374696F6E3B6966286C656E6774683D3D3D302626706172656E742E5F7374617465297B6C6962246573362470726F6D6973652461736170242461736170286C69622465733624';
wwv_flow_api.g_varchar2_table(86) := '70726F6D6973652424696E7465726E616C24247075626C6973682C706172656E74297D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24247075626C6973682870726F6D697365297B7661722073756273637269';
wwv_flow_api.g_varchar2_table(87) := '626572733D70726F6D6973652E5F73756273637269626572733B76617220736574746C65643D70726F6D6973652E5F73746174653B69662873756273637269626572732E6C656E6774683D3D3D30297B72657475726E7D766172206368696C642C63616C';
wwv_flow_api.g_varchar2_table(88) := '6C6261636B2C64657461696C3D70726F6D6973652E5F726573756C743B666F722876617220693D303B693C73756273637269626572732E6C656E6774683B692B3D33297B6368696C643D73756273637269626572735B695D3B63616C6C6261636B3D7375';
wwv_flow_api.g_varchar2_table(89) := '6273637269626572735B692B736574746C65645D3B6966286368696C64297B6C6962246573362470726F6D6973652424696E7465726E616C2424696E766F6B6543616C6C6261636B28736574746C65642C6368696C642C63616C6C6261636B2C64657461';
wwv_flow_api.g_varchar2_table(90) := '696C297D656C73657B63616C6C6261636B2864657461696C297D7D70726F6D6973652E5F73756273637269626572732E6C656E6774683D307D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C24244572726F724F62';
wwv_flow_api.g_varchar2_table(91) := '6A65637428297B746869732E6572726F723D6E756C6C7D766172206C6962246573362470726F6D6973652424696E7465726E616C24245452595F43415443485F4552524F523D6E6577206C6962246573362470726F6D6973652424696E7465726E616C24';
wwv_flow_api.g_varchar2_table(92) := '244572726F724F626A6563743B66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C242474727943617463682863616C6C6261636B2C64657461696C297B7472797B72657475726E2063616C6C6261636B286465746169';
wwv_flow_api.g_varchar2_table(93) := '6C297D63617463682865297B6C6962246573362470726F6D6973652424696E7465726E616C24245452595F43415443485F4552524F522E6572726F723D653B72657475726E206C6962246573362470726F6D6973652424696E7465726E616C2424545259';
wwv_flow_api.g_varchar2_table(94) := '5F43415443485F4552524F527D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C2424696E766F6B6543616C6C6261636B28736574746C65642C70726F6D6973652C63616C6C6261636B2C64657461696C297B7661';
wwv_flow_api.g_varchar2_table(95) := '722068617343616C6C6261636B3D6C6962246573362470726F6D697365247574696C732424697346756E6374696F6E2863616C6C6261636B292C76616C75652C6572726F722C7375636365656465642C6661696C65643B69662868617343616C6C626163';
wwv_flow_api.g_varchar2_table(96) := '6B297B76616C75653D6C6962246573362470726F6D6973652424696E7465726E616C242474727943617463682863616C6C6261636B2C64657461696C293B69662876616C75653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C2424';
wwv_flow_api.g_varchar2_table(97) := '5452595F43415443485F4552524F52297B6661696C65643D747275653B6572726F723D76616C75652E6572726F723B76616C75653D6E756C6C7D656C73657B7375636365656465643D747275657D69662870726F6D6973653D3D3D76616C7565297B6C69';
wwv_flow_api.g_varchar2_table(98) := '62246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C6C6962246573362470726F6D6973652424696E7465726E616C242463616E6E6F7452657475726E4F776E2829293B72657475726E7D7D656C73657B76';
wwv_flow_api.g_varchar2_table(99) := '616C75653D64657461696C3B7375636365656465643D747275657D69662870726F6D6973652E5F7374617465213D3D6C6962246573362470726F6D6973652424696E7465726E616C242450454E44494E47297B7D656C73652069662868617343616C6C62';
wwv_flow_api.g_varchar2_table(100) := '61636B2626737563636565646564297B6C6962246573362470726F6D6973652424696E7465726E616C24247265736F6C76652870726F6D6973652C76616C7565297D656C7365206966286661696C6564297B6C6962246573362470726F6D697365242469';
wwv_flow_api.g_varchar2_table(101) := '6E7465726E616C242472656A6563742870726F6D6973652C6572726F72297D656C736520696628736574746C65643D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242446554C46494C4C4544297B6C6962246573362470726F6D69';
wwv_flow_api.g_varchar2_table(102) := '73652424696E7465726E616C242466756C66696C6C2870726F6D6973652C76616C7565297D656C736520696628736574746C65643D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242452454A4543544544297B6C69622465733624';
wwv_flow_api.g_varchar2_table(103) := '70726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C76616C7565297D7D66756E6374696F6E206C6962246573362470726F6D6973652424696E7465726E616C2424696E697469616C697A6550726F6D6973652870726F6D';
wwv_flow_api.g_varchar2_table(104) := '6973652C7265736F6C766572297B7472797B7265736F6C7665722866756E6374696F6E207265736F6C766550726F6D6973652876616C7565297B6C6962246573362470726F6D6973652424696E7465726E616C24247265736F6C76652870726F6D697365';
wwv_flow_api.g_varchar2_table(105) := '2C76616C7565297D2C66756E6374696F6E2072656A65637450726F6D69736528726561736F6E297B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C726561736F6E297D297D6361746368286529';
wwv_flow_api.g_varchar2_table(106) := '7B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C65297D7D66756E6374696F6E206C6962246573362470726F6D69736524656E756D657261746F722424456E756D657261746F7228436F6E7374';
wwv_flow_api.g_varchar2_table(107) := '727563746F722C696E707574297B76617220656E756D657261746F723D746869733B656E756D657261746F722E5F696E7374616E6365436F6E7374727563746F723D436F6E7374727563746F723B656E756D657261746F722E70726F6D6973653D6E6577';
wwv_flow_api.g_varchar2_table(108) := '20436F6E7374727563746F72286C6962246573362470726F6D6973652424696E7465726E616C24246E6F6F70293B696628656E756D657261746F722E5F76616C6964617465496E70757428696E70757429297B656E756D657261746F722E5F696E707574';
wwv_flow_api.g_varchar2_table(109) := '3D696E7075743B656E756D657261746F722E6C656E6774683D696E7075742E6C656E6774683B656E756D657261746F722E5F72656D61696E696E673D696E7075742E6C656E6774683B656E756D657261746F722E5F696E697428293B696628656E756D65';
wwv_flow_api.g_varchar2_table(110) := '7261746F722E6C656E6774683D3D3D30297B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C28656E756D657261746F722E70726F6D6973652C656E756D657261746F722E5F726573756C74297D656C73657B656E75';
wwv_flow_api.g_varchar2_table(111) := '6D657261746F722E6C656E6774683D656E756D657261746F722E6C656E6774687C7C303B656E756D657261746F722E5F656E756D657261746528293B696628656E756D657261746F722E5F72656D61696E696E673D3D3D30297B6C696224657336247072';
wwv_flow_api.g_varchar2_table(112) := '6F6D6973652424696E7465726E616C242466756C66696C6C28656E756D657261746F722E70726F6D6973652C656E756D657261746F722E5F726573756C74297D7D7D656C73657B6C6962246573362470726F6D6973652424696E7465726E616C24247265';
wwv_flow_api.g_varchar2_table(113) := '6A65637428656E756D657261746F722E70726F6D6973652C656E756D657261746F722E5F76616C69646174696F6E4572726F722829297D7D6C6962246573362470726F6D69736524656E756D657261746F722424456E756D657261746F722E70726F746F';
wwv_flow_api.g_varchar2_table(114) := '747970652E5F76616C6964617465496E7075743D66756E6374696F6E28696E707574297B72657475726E206C6962246573362470726F6D697365247574696C7324246973417272617928696E707574297D3B6C6962246573362470726F6D69736524656E';
wwv_flow_api.g_varchar2_table(115) := '756D657261746F722424456E756D657261746F722E70726F746F747970652E5F76616C69646174696F6E4572726F723D66756E6374696F6E28297B72657475726E206E6577204572726F7228224172726179204D6574686F6473206D7573742062652070';
wwv_flow_api.g_varchar2_table(116) := '726F766964656420616E20417272617922297D3B6C6962246573362470726F6D69736524656E756D657261746F722424456E756D657261746F722E70726F746F747970652E5F696E69743D66756E6374696F6E28297B746869732E5F726573756C743D6E';
wwv_flow_api.g_varchar2_table(117) := '657720417272617928746869732E6C656E677468297D3B766172206C6962246573362470726F6D69736524656E756D657261746F72242464656661756C743D6C6962246573362470726F6D69736524656E756D657261746F722424456E756D657261746F';
wwv_flow_api.g_varchar2_table(118) := '723B6C6962246573362470726F6D69736524656E756D657261746F722424456E756D657261746F722E70726F746F747970652E5F656E756D65726174653D66756E6374696F6E28297B76617220656E756D657261746F723D746869733B766172206C656E';
wwv_flow_api.g_varchar2_table(119) := '6774683D656E756D657261746F722E6C656E6774683B7661722070726F6D6973653D656E756D657261746F722E70726F6D6973653B76617220696E7075743D656E756D657261746F722E5F696E7075743B666F722876617220693D303B70726F6D697365';
wwv_flow_api.g_varchar2_table(120) := '2E5F73746174653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242450454E44494E472626693C6C656E6774683B692B2B297B656E756D657261746F722E5F65616368456E74727928696E7075745B695D2C69297D7D3B6C696224';
wwv_flow_api.g_varchar2_table(121) := '6573362470726F6D69736524656E756D657261746F722424456E756D657261746F722E70726F746F747970652E5F65616368456E7472793D66756E6374696F6E28656E7472792C69297B76617220656E756D657261746F723D746869733B76617220633D';
wwv_flow_api.g_varchar2_table(122) := '656E756D657261746F722E5F696E7374616E6365436F6E7374727563746F723B6966286C6962246573362470726F6D697365247574696C73242469734D617962655468656E61626C6528656E74727929297B696628656E7472792E636F6E737472756374';
wwv_flow_api.g_varchar2_table(123) := '6F723D3D3D632626656E7472792E5F7374617465213D3D6C6962246573362470726F6D6973652424696E7465726E616C242450454E44494E47297B656E7472792E5F6F6E6572726F723D6E756C6C3B656E756D657261746F722E5F736574746C65644174';
wwv_flow_api.g_varchar2_table(124) := '28656E7472792E5F73746174652C692C656E7472792E5F726573756C74297D656C73657B656E756D657261746F722E5F77696C6C536574746C65417428632E7265736F6C766528656E747279292C69297D7D656C73657B656E756D657261746F722E5F72';
wwv_flow_api.g_varchar2_table(125) := '656D61696E696E672D2D3B656E756D657261746F722E5F726573756C745B695D3D656E7472797D7D3B6C6962246573362470726F6D69736524656E756D657261746F722424456E756D657261746F722E70726F746F747970652E5F736574746C65644174';
wwv_flow_api.g_varchar2_table(126) := '3D66756E6374696F6E2873746174652C692C76616C7565297B76617220656E756D657261746F723D746869733B7661722070726F6D6973653D656E756D657261746F722E70726F6D6973653B69662870726F6D6973652E5F73746174653D3D3D6C696224';
wwv_flow_api.g_varchar2_table(127) := '6573362470726F6D6973652424696E7465726E616C242450454E44494E47297B656E756D657261746F722E5F72656D61696E696E672D2D3B69662873746174653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242452454A454354';
wwv_flow_api.g_varchar2_table(128) := '4544297B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C76616C7565297D656C73657B656E756D657261746F722E5F726573756C745B695D3D76616C75657D7D696628656E756D657261746F72';
wwv_flow_api.g_varchar2_table(129) := '2E5F72656D61696E696E673D3D3D30297B6C6962246573362470726F6D6973652424696E7465726E616C242466756C66696C6C2870726F6D6973652C656E756D657261746F722E5F726573756C74297D7D3B6C6962246573362470726F6D69736524656E';
wwv_flow_api.g_varchar2_table(130) := '756D657261746F722424456E756D657261746F722E70726F746F747970652E5F77696C6C536574746C6541743D66756E6374696F6E2870726F6D6973652C69297B76617220656E756D657261746F723D746869733B6C6962246573362470726F6D697365';
wwv_flow_api.g_varchar2_table(131) := '2424696E7465726E616C24247375627363726962652870726F6D6973652C756E646566696E65642C66756E6374696F6E2876616C7565297B656E756D657261746F722E5F736574746C65644174286C6962246573362470726F6D6973652424696E746572';
wwv_flow_api.g_varchar2_table(132) := '6E616C242446554C46494C4C45442C692C76616C7565297D2C66756E6374696F6E28726561736F6E297B656E756D657261746F722E5F736574746C65644174286C6962246573362470726F6D6973652424696E7465726E616C242452454A45435445442C';
wwv_flow_api.g_varchar2_table(133) := '692C726561736F6E297D297D3B66756E6374696F6E206C6962246573362470726F6D6973652470726F6D69736524616C6C2424616C6C28656E7472696573297B72657475726E206E6577206C6962246573362470726F6D69736524656E756D657261746F';
wwv_flow_api.g_varchar2_table(134) := '72242464656661756C7428746869732C656E7472696573292E70726F6D6973657D766172206C6962246573362470726F6D6973652470726F6D69736524616C6C242464656661756C743D6C6962246573362470726F6D6973652470726F6D69736524616C';
wwv_flow_api.g_varchar2_table(135) := '6C2424616C6C3B66756E6374696F6E206C6962246573362470726F6D6973652470726F6D697365247261636524247261636528656E7472696573297B76617220436F6E7374727563746F723D746869733B7661722070726F6D6973653D6E657720436F6E';
wwv_flow_api.g_varchar2_table(136) := '7374727563746F72286C6962246573362470726F6D6973652424696E7465726E616C24246E6F6F70293B696628216C6962246573362470726F6D697365247574696C7324246973417272617928656E747269657329297B6C6962246573362470726F6D69';
wwv_flow_api.g_varchar2_table(137) := '73652424696E7465726E616C242472656A6563742870726F6D6973652C6E657720547970654572726F722822596F75206D757374207061737320616E20617272617920746F20726163652E2229293B72657475726E2070726F6D6973657D766172206C65';
wwv_flow_api.g_varchar2_table(138) := '6E6774683D656E74726965732E6C656E6774683B66756E6374696F6E206F6E46756C66696C6C6D656E742876616C7565297B6C6962246573362470726F6D6973652424696E7465726E616C24247265736F6C76652870726F6D6973652C76616C7565297D';
wwv_flow_api.g_varchar2_table(139) := '66756E6374696F6E206F6E52656A656374696F6E28726561736F6E297B6C6962246573362470726F6D6973652424696E7465726E616C242472656A6563742870726F6D6973652C726561736F6E297D666F722876617220693D303B70726F6D6973652E5F';
wwv_flow_api.g_varchar2_table(140) := '73746174653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242450454E44494E472626693C6C656E6774683B692B2B297B6C6962246573362470726F6D6973652424696E7465726E616C242473756273637269626528436F6E7374';
wwv_flow_api.g_varchar2_table(141) := '727563746F722E7265736F6C766528656E74726965735B695D292C756E646566696E65642C6F6E46756C66696C6C6D656E742C6F6E52656A656374696F6E297D72657475726E2070726F6D6973657D766172206C6962246573362470726F6D6973652470';
wwv_flow_api.g_varchar2_table(142) := '726F6D6973652472616365242464656661756C743D6C6962246573362470726F6D6973652470726F6D69736524726163652424726163653B66756E6374696F6E206C6962246573362470726F6D6973652470726F6D697365247265736F6C766524247265';
wwv_flow_api.g_varchar2_table(143) := '736F6C7665286F626A656374297B76617220436F6E7374727563746F723D746869733B6966286F626A6563742626747970656F66206F626A6563743D3D3D226F626A6563742226266F626A6563742E636F6E7374727563746F723D3D3D436F6E73747275';
wwv_flow_api.g_varchar2_table(144) := '63746F72297B72657475726E206F626A6563747D7661722070726F6D6973653D6E657720436F6E7374727563746F72286C6962246573362470726F6D6973652424696E7465726E616C24246E6F6F70293B6C6962246573362470726F6D6973652424696E';
wwv_flow_api.g_varchar2_table(145) := '7465726E616C24247265736F6C76652870726F6D6973652C6F626A656374293B72657475726E2070726F6D6973657D766172206C6962246573362470726F6D6973652470726F6D697365247265736F6C7665242464656661756C743D6C69622465733624';
wwv_flow_api.g_varchar2_table(146) := '70726F6D6973652470726F6D697365247265736F6C766524247265736F6C76653B66756E6374696F6E206C6962246573362470726F6D6973652470726F6D6973652472656A656374242472656A65637428726561736F6E297B76617220436F6E73747275';
wwv_flow_api.g_varchar2_table(147) := '63746F723D746869733B7661722070726F6D6973653D6E657720436F6E7374727563746F72286C6962246573362470726F6D6973652424696E7465726E616C24246E6F6F70293B6C6962246573362470726F6D6973652424696E7465726E616C24247265';
wwv_flow_api.g_varchar2_table(148) := '6A6563742870726F6D6973652C726561736F6E293B72657475726E2070726F6D6973657D766172206C6962246573362470726F6D6973652470726F6D6973652472656A656374242464656661756C743D6C6962246573362470726F6D6973652470726F6D';
wwv_flow_api.g_varchar2_table(149) := '6973652472656A656374242472656A6563743B766172206C6962246573362470726F6D6973652470726F6D6973652424636F756E7465723D303B66756E6374696F6E206C6962246573362470726F6D6973652470726F6D69736524246E65656473526573';
wwv_flow_api.g_varchar2_table(150) := '6F6C76657228297B7468726F77206E657720547970654572726F722822596F75206D75737420706173732061207265736F6C7665722066756E6374696F6E2061732074686520666972737420617267756D656E7420746F207468652070726F6D69736520';
wwv_flow_api.g_varchar2_table(151) := '636F6E7374727563746F7222297D66756E6374696F6E206C6962246573362470726F6D6973652470726F6D69736524246E656564734E657728297B7468726F77206E657720547970654572726F7228224661696C656420746F20636F6E73747275637420';
wwv_flow_api.g_varchar2_table(152) := '2750726F6D697365273A20506C65617365207573652074686520276E657727206F70657261746F722C2074686973206F626A65637420636F6E7374727563746F722063616E6E6F742062652063616C6C656420617320612066756E6374696F6E2E22297D';
wwv_flow_api.g_varchar2_table(153) := '766172206C6962246573362470726F6D6973652470726F6D697365242464656661756C743D6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973653B66756E6374696F6E206C6962246573362470726F6D6973652470726F6D69';
wwv_flow_api.g_varchar2_table(154) := '7365242450726F6D697365287265736F6C766572297B746869732E5F69643D6C6962246573362470726F6D6973652470726F6D6973652424636F756E7465722B2B3B746869732E5F73746174653D756E646566696E65643B746869732E5F726573756C74';
wwv_flow_api.g_varchar2_table(155) := '3D756E646566696E65643B746869732E5F73756273637269626572733D5B5D3B6966286C6962246573362470726F6D6973652424696E7465726E616C24246E6F6F70213D3D7265736F6C766572297B696628216C6962246573362470726F6D6973652475';
wwv_flow_api.g_varchar2_table(156) := '74696C732424697346756E6374696F6E287265736F6C76657229297B6C6962246573362470726F6D6973652470726F6D69736524246E656564735265736F6C76657228297D69662821287468697320696E7374616E63656F66206C696224657336247072';
wwv_flow_api.g_varchar2_table(157) := '6F6D6973652470726F6D697365242450726F6D69736529297B6C6962246573362470726F6D6973652470726F6D69736524246E656564734E657728297D6C6962246573362470726F6D6973652424696E7465726E616C2424696E697469616C697A655072';
wwv_flow_api.g_varchar2_table(158) := '6F6D69736528746869732C7265736F6C766572297D7D6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973652E616C6C3D6C6962246573362470726F6D6973652470726F6D69736524616C6C242464656661756C743B6C696224';
wwv_flow_api.g_varchar2_table(159) := '6573362470726F6D6973652470726F6D697365242450726F6D6973652E726163653D6C6962246573362470726F6D6973652470726F6D6973652472616365242464656661756C743B6C6962246573362470726F6D6973652470726F6D697365242450726F';
wwv_flow_api.g_varchar2_table(160) := '6D6973652E7265736F6C76653D6C6962246573362470726F6D6973652470726F6D697365247265736F6C7665242464656661756C743B6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973652E72656A6563743D6C6962246573';
wwv_flow_api.g_varchar2_table(161) := '362470726F6D6973652470726F6D6973652472656A656374242464656661756C743B6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973652E5F7365745363686564756C65723D6C6962246573362470726F6D69736524617361';
wwv_flow_api.g_varchar2_table(162) := '7024247365745363686564756C65723B6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973652E5F736574417361703D6C6962246573362470726F6D69736524617361702424736574417361703B6C6962246573362470726F6D';
wwv_flow_api.g_varchar2_table(163) := '6973652470726F6D697365242450726F6D6973652E5F617361703D6C6962246573362470726F6D69736524617361702424617361703B6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973652E70726F746F747970653D7B636F';
wwv_flow_api.g_varchar2_table(164) := '6E7374727563746F723A6C6962246573362470726F6D6973652470726F6D697365242450726F6D6973652C7468656E3A66756E6374696F6E286F6E46756C66696C6C6D656E742C6F6E52656A656374696F6E297B76617220706172656E743D746869733B';
wwv_flow_api.g_varchar2_table(165) := '7661722073746174653D706172656E742E5F73746174653B69662873746174653D3D3D6C6962246573362470726F6D6973652424696E7465726E616C242446554C46494C4C45442626216F6E46756C66696C6C6D656E747C7C73746174653D3D3D6C6962';
wwv_flow_api.g_varchar2_table(166) := '246573362470726F6D6973652424696E7465726E616C242452454A45435445442626216F6E52656A656374696F6E297B72657475726E20746869737D766172206368696C643D6E657720746869732E636F6E7374727563746F72286C6962246573362470';
wwv_flow_api.g_varchar2_table(167) := '726F6D6973652424696E7465726E616C24246E6F6F70293B76617220726573756C743D706172656E742E5F726573756C743B6966287374617465297B7661722063616C6C6261636B3D617267756D656E74735B73746174652D315D3B6C69622465733624';
wwv_flow_api.g_varchar2_table(168) := '70726F6D69736524617361702424617361702866756E6374696F6E28297B6C6962246573362470726F6D6973652424696E7465726E616C2424696E766F6B6543616C6C6261636B2873746174652C6368696C642C63616C6C6261636B2C726573756C7429';
wwv_flow_api.g_varchar2_table(169) := '7D297D656C73657B6C6962246573362470726F6D6973652424696E7465726E616C242473756273637269626528706172656E742C6368696C642C6F6E46756C66696C6C6D656E742C6F6E52656A656374696F6E297D72657475726E206368696C647D2C22';
wwv_flow_api.g_varchar2_table(170) := '6361746368223A66756E6374696F6E286F6E52656A656374696F6E297B72657475726E20746869732E7468656E286E756C6C2C6F6E52656A656374696F6E297D7D3B66756E6374696F6E206C6962246573362470726F6D69736524706F6C7966696C6C24';
wwv_flow_api.g_varchar2_table(171) := '24706F6C7966696C6C28297B766172206C6F63616C3B696628747970656F6620676C6F62616C213D3D22756E646566696E656422297B6C6F63616C3D676C6F62616C7D656C736520696628747970656F662073656C66213D3D22756E646566696E656422';
wwv_flow_api.g_varchar2_table(172) := '297B6C6F63616C3D73656C667D656C73657B7472797B6C6F63616C3D46756E6374696F6E282272657475726E2074686973222928297D63617463682865297B7468726F77206E6577204572726F722822706F6C7966696C6C206661696C65642062656361';
wwv_flow_api.g_varchar2_table(173) := '75736520676C6F62616C206F626A65637420697320756E617661696C61626C6520696E207468697320656E7669726F6E6D656E7422297D7D76617220503D6C6F63616C2E50726F6D6973653B6966285026264F626A6563742E70726F746F747970652E74';
wwv_flow_api.g_varchar2_table(174) := '6F537472696E672E63616C6C28502E7265736F6C76652829293D3D3D225B6F626A6563742050726F6D6973655D22262621502E63617374297B72657475726E7D6C6F63616C2E50726F6D6973653D6C6962246573362470726F6D6973652470726F6D6973';
wwv_flow_api.g_varchar2_table(175) := '65242464656661756C747D766172206C6962246573362470726F6D69736524706F6C7966696C6C242464656661756C743D6C6962246573362470726F6D69736524706F6C7966696C6C2424706F6C7966696C6C3B766172206C6962246573362470726F6D';
wwv_flow_api.g_varchar2_table(176) := '69736524756D64242445533650726F6D6973653D7B50726F6D6973653A6C6962246573362470726F6D6973652470726F6D697365242464656661756C742C706F6C7966696C6C3A6C6962246573362470726F6D69736524706F6C7966696C6C2424646566';
wwv_flow_api.g_varchar2_table(177) := '61756C747D3B696628747970656F6620646566696E653D3D3D2266756E6374696F6E222626646566696E655B22616D64225D297B646566696E652866756E6374696F6E28297B72657475726E206C6962246573362470726F6D69736524756D6424244553';
wwv_flow_api.g_varchar2_table(178) := '3650726F6D6973657D297D656C736520696628747970656F66206D6F64756C65213D3D22756E646566696E65642226266D6F64756C655B226578706F727473225D297B6D6F64756C655B226578706F727473225D3D6C6962246573362470726F6D697365';
wwv_flow_api.g_varchar2_table(179) := '24756D64242445533650726F6D6973657D656C736520696628747970656F662074686973213D3D22756E646566696E656422297B746869735B2245533650726F6D697365225D3D6C6962246573362470726F6D69736524756D64242445533650726F6D69';
wwv_flow_api.g_varchar2_table(180) := '73657D6C6962246573362470726F6D69736524706F6C7966696C6C242464656661756C7428297D292E63616C6C2874686973293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(20922455082759991242)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_file_name=>'es6-promise.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A202A20466972656275672F57656220496E73706563746F72204F75746C696E6520496D706C656D656E746174696F6E207573696E67206A51756572790A202A2054657374656420746F20776F726B20696E204368726F6D652C2046462C205361';
wwv_flow_api.g_varchar2_table(2) := '666172692E20427567677920696E204945203B280A202A20416E64726577204368696C6473203C616340676C6F6D65726174652E636F6D3E0A202A0A202A204578616D706C652053657475703A0A202A20766172206D79436C69636B48616E646C657220';
wwv_flow_api.g_varchar2_table(3) := '3D2066756E6374696F6E2028656C656D656E7429207B20636F6E736F6C652E6C6F672827436C69636B656420656C656D656E743A272C20656C656D656E74293B207D0A202A20766172206D79446F6D4F75746C696E65203D20446F6D4F75746C696E6528';
wwv_flow_api.g_varchar2_table(4) := '7B206F6E436C69636B3A206D79436C69636B48616E646C65722C2066696C7465723A20272E646562756727207D293B0A202A0A202A205075626C6963204150493A0A202A206D79446F6D4F75746C696E652E737461727428293B0A202A206D79446F6D4F';
wwv_flow_api.g_varchar2_table(5) := '75746C696E652E73746F7028293B0A202A2F0A76617220446F6D4F75746C696E65203D2066756E6374696F6E20286F7074696F6E7329207B0A202020206F7074696F6E73203D206F7074696F6E73207C7C207B7D3B0A0A2020202076617220707562203D';
wwv_flow_api.g_varchar2_table(6) := '207B7D3B0A202020207661722073656C66203D207B0A20202020202020206F7074733A207B0A2020202020202020202020206E616D6573706163653A206F7074696F6E732E6E616D657370616365207C7C2027446F6D4F75746C696E65272C0A20202020';
wwv_flow_api.g_varchar2_table(7) := '2020202020202020626F7264657257696474683A206F7074696F6E732E626F726465725769647468207C7C20322C0A202020202020202020202020626F72646572436F6C6F723A206F7074696F6E732E626F72646572436F6C6F72207C7C202723303963';
wwv_flow_api.g_varchar2_table(8) := '272C0A2020202020202020202020206F6E436C69636B3A206F7074696F6E732E6F6E436C69636B207C7C2066616C73652C0A20202020202020202020202066696C7465723A206F7074696F6E732E66696C746572207C7C2066616C73652C0A2020202020';
wwv_flow_api.g_varchar2_table(9) := '20202020202020646F6E7453746F703A20216F7074696F6E732E73746F704F6E436C69636B207C7C2066616C73652C0A202020202020202020202020686964654C6162656C3A206F7074696F6E732E686964654C6162656C207C7C2066616C73652C0A20';
wwv_flow_api.g_varchar2_table(10) := '202020202020202020202066696C6C436F6E74656E743A206F7074696F6E732E66696C6C436F6E74656E74207C7C2066616C73650A20202020202020207D2C0A20202020202020206B6579436F6465733A207B0A2020202020202020202020204241434B';
wwv_flow_api.g_varchar2_table(11) := '53504143453A20382C0A2020202020202020202020204553433A2032372C0A20202020202020202020202044454C4554453A2034360A20202020202020207D2C0A20202020202020206163746976653A2066616C73652C0A2020202020202020696E6974';
wwv_flow_api.g_varchar2_table(12) := '69616C697A65643A2066616C73652C0A2020202020202020656C656D656E74733A207B7D0A202020207D3B0A202020200A2020202066756E6374696F6E20436F6C6F724C756D696E616E6365286865782C206C756D29207B0A09202020202F2F2076616C';
wwv_flow_api.g_varchar2_table(13) := '69646174652068657820737472696E670A0920202020686578203D20537472696E6728686578292E7265706C616365282F5B5E302D39612D665D2F67692C202727293B0A0920202020696620286865782E6C656E677468203C203629207B0A0909202020';
wwv_flow_api.g_varchar2_table(14) := '20686578203D206865785B305D2B6865785B305D2B6865785B315D2B6865785B315D2B6865785B325D2B6865785B325D3B0A09202020207D0A09202020206C756D203D206C756D207C7C20303B0A09202020202F2F20636F6E7665727420746F20646563';
wwv_flow_api.g_varchar2_table(15) := '696D616C20616E64206368616E6765206C756D696E6F736974790A092020202076617220726762203D202223222C20632C20693B0A0920202020666F72202869203D20303B2069203C20333B20692B2B29207B0A09092020202063203D20706172736549';
wwv_flow_api.g_varchar2_table(16) := '6E74286865782E73756273747228692A322C32292C203136293B0A09092020202063203D204D6174682E726F756E64284D6174682E6D696E284D6174682E6D617828302C2063202B202863202A206C756D29292C2032353529292E746F537472696E6728';
wwv_flow_api.g_varchar2_table(17) := '3136293B0A090920202020726762202B3D2028223030222B63292E73756273747228632E6C656E677468293B0A09202020207D0A092020202072657475726E207267623B0A202020207D0A0A2020202066756E6374696F6E20686578546F526762286865';
wwv_flow_api.g_varchar2_table(18) := '7829207B0A20202020202020202F2F20457870616E642073686F727468616E6420666F726D2028652E672E2022303346222920746F2066756C6C20666F726D2028652E672E202230303333464622290A20202020202020207661722073686F727468616E';
wwv_flow_api.g_varchar2_table(19) := '645265676578203D202F5E233F285B612D665C645D29285B612D665C645D29285B612D665C645D29242F693B0A2020202020202020686578203D206865782E7265706C6163652873686F727468616E6452656765782C2066756E6374696F6E286D2C2072';
wwv_flow_api.g_varchar2_table(20) := '2C20672C206229207B0A20202020202020202020202072657475726E2072202B2072202B2067202B2067202B2062202B20623B0A20202020202020207D293B0A202020202020202076617220726573756C74203D202F5E233F285B612D665C645D7B327D';
wwv_flow_api.g_varchar2_table(21) := '29285B612D665C645D7B327D29285B612D665C645D7B327D29242F692E6578656328686578293B0A202020202020202072657475726E20726573756C74203F207B0A202020202020202020202020723A207061727365496E7428726573756C745B315D2C';
wwv_flow_api.g_varchar2_table(22) := '203136292C0A202020202020202020202020673A207061727365496E7428726573756C745B325D2C203136292C0A202020202020202020202020623A207061727365496E7428726573756C745B335D2C203136290A20202020202020207D203A206E756C';
wwv_flow_api.g_varchar2_table(23) := '6C3B0A202020207D0A0A20200A2020202066756E6374696F6E2077726974655374796C6573686565742863737329207B0A202020202020202076617220656C656D656E74203D20646F63756D656E742E637265617465456C656D656E7428277374796C65';
wwv_flow_api.g_varchar2_table(24) := '27293B0A2020202020202020656C656D656E742E74797065203D2027746578742F637373273B0A2020202020202020646F63756D656E742E676574456C656D656E747342795461674E616D6528276865616427295B305D2E617070656E644368696C6428';
wwv_flow_api.g_varchar2_table(25) := '656C656D656E74293B0A0A202020202020202069662028656C656D656E742E7374796C65536865657429207B0A202020202020202020202020656C656D656E742E7374796C6553686565742E63737354657874203D206373733B202F2F2049450A202020';
wwv_flow_api.g_varchar2_table(26) := '20202020207D20656C7365207B0A202020202020202020202020656C656D656E742E696E6E657248544D4C203D206373733B202F2F204E6F6E2D49450A20202020202020207D0A202020207D0A0A2020202066756E6374696F6E20696E69745374796C65';
wwv_flow_api.g_varchar2_table(27) := '73686565742829207B0A20202020202020206966202873656C662E696E697469616C697A656420213D3D207472756529207B0A2020202020202020202020202F2F20333025206461726B657220636F6C6F7220666F7220636F6E74656E740A2020202020';
wwv_flow_api.g_varchar2_table(28) := '2020202020202076617220636F6E74656E74436F6C6F72203D20436F6C6F724C756D696E616E63652873656C662E6F7074732E626F72646572436F6C6F722C202D302E33293B0A20202020202020202020202076617220636F6E74656E74436F6C6F7252';
wwv_flow_api.g_varchar2_table(29) := '4742203D20686578546F52676228636F6E74656E74436F6C6F72292E72202B20272C2027202B20686578546F52676228636F6E74656E74436F6C6F72292E67202B20272C2027202B20686578546F52676228636F6E74656E74436F6C6F72292E623B0A20';
wwv_flow_api.g_varchar2_table(30) := '20202020202020202020202F2F206275696C64206373730A20202020202020202020202076617220637373203D202727202B0A20202020202020202020202020202020272E27202B2073656C662E6F7074732E6E616D657370616365202B2027207B2720';
wwv_flow_api.g_varchar2_table(31) := '2B0A2020202020202020202020202020202027202020206261636B67726F756E643A2027202B2073656C662E6F7074732E626F72646572436F6C6F72202B20273B27202B0A202020202020202020202020202020202720202020706F736974696F6E3A20';
wwv_flow_api.g_varchar2_table(32) := '6162736F6C7574653B27202B0A2020202020202020202020202020202027202020207A2D696E6465783A20313030303030303B27202B0A20202020202020202020202020202020277D27202B0A20202020202020202020202020202020272E27202B2073';
wwv_flow_api.g_varchar2_table(33) := '656C662E6F7074732E6E616D657370616365202B20275F6C6162656C207B27202B0A2020202020202020202020202020202027202020206261636B67726F756E643A2027202B2073656C662E6F7074732E626F72646572436F6C6F72202B20273B27202B';
wwv_flow_api.g_varchar2_table(34) := '0A202020202020202020202020202020202720202020626F726465722D7261646975733A203270783B27202B0A202020202020202020202020202020202720202020636F6C6F723A20236666663B27202B0A202020202020202020202020202020202720';
wwv_flow_api.g_varchar2_table(35) := '202020666F6E743A20626F6C6420313270782F313270782048656C7665746963612C2073616E732D73657269663B27202B0A20202020202020202020202020202020272020202070616464696E673A20347078203670783B27202B0A2020202020202020';
wwv_flow_api.g_varchar2_table(36) := '20202020202020202720202020706F736974696F6E3A206162736F6C7574653B27202B0A202020202020202020202020202020202720202020746578742D736861646F773A20302031707820317078207267626128302C20302C20302C20302E3235293B';
wwv_flow_api.g_varchar2_table(37) := '27202B0A2020202020202020202020202020202027202020207A2D696E6465783A20313030303030313B27202B0A20202020202020202020202020202020277D27202B0A20202020202020202020202020202020272E27202B2073656C662E6F7074732E';
wwv_flow_api.g_varchar2_table(38) := '6E616D657370616365202B20275F6C6162656C2E68696464656E207B27202B0A202020202020202020202020202020202720202020646973706C61793A206E6F6E653B27202B0A20202020202020202020202020202020277D27202B0A20202020202020';
wwv_flow_api.g_varchar2_table(39) := '202020202020202020272E27202B2073656C662E6F7074732E6E616D657370616365202B20275F66696C6C5F636F6E74656E74207B27202B0A2020202020202020202020202020202027202020206261636B67726F756E643A20726762612827202B2063';
wwv_flow_api.g_varchar2_table(40) := '6F6E74656E74436F6C6F72524742202B20272C20302E33292021696D706F7274616E743B27202B0A2020202020202020202020202020202027202020206261636B67726F756E642D636F6C6F723A20726762612827202B20636F6E74656E74436F6C6F72';
wwv_flow_api.g_varchar2_table(41) := '524742202B20272C20302E33292021696D706F7274616E743B27202B0A20202020202020202020202020202020277D273B0A0A20202020202020202020202077726974655374796C65736865657428637373293B0A20202020202020202020202073656C';
wwv_flow_api.g_varchar2_table(42) := '662E696E697469616C697A6564203D20747275653B0A20202020202020207D0A202020207D0A0A2020202066756E6374696F6E206372656174654F75746C696E65456C656D656E74732829207B0A202020202020202073656C662E656C656D656E74732E';
wwv_flow_api.g_varchar2_table(43) := '6C6162656C203D206A517565727928273C6469763E3C2F6469763E27292E616464436C6173732873656C662E6F7074732E6E616D657370616365202B20275F6C6162656C2068696464656E27292E617070656E64546F2827626F647927293B0A20202020';
wwv_flow_api.g_varchar2_table(44) := '2020202073656C662E656C656D656E74732E746F70203D206A517565727928273C6469763E3C2F6469763E27292E616464436C6173732873656C662E6F7074732E6E616D657370616365292E617070656E64546F2827626F647927293B0A202020202020';
wwv_flow_api.g_varchar2_table(45) := '202073656C662E656C656D656E74732E626F74746F6D203D206A517565727928273C6469763E3C2F6469763E27292E616464436C6173732873656C662E6F7074732E6E616D657370616365292E617070656E64546F2827626F647927293B0A2020202020';
wwv_flow_api.g_varchar2_table(46) := '20202073656C662E656C656D656E74732E6C656674203D206A517565727928273C6469763E3C2F6469763E27292E616464436C6173732873656C662E6F7074732E6E616D657370616365292E617070656E64546F2827626F647927293B0A202020202020';
wwv_flow_api.g_varchar2_table(47) := '202073656C662E656C656D656E74732E7269676874203D206A517565727928273C6469763E3C2F6469763E27292E616464436C6173732873656C662E6F7074732E6E616D657370616365292E617070656E64546F2827626F647927293B0A202020207D0A';
wwv_flow_api.g_varchar2_table(48) := '0A2020202066756E6374696F6E2072656D6F76654F75746C696E65456C656D656E74732829207B0A20202020202020206A51756572792E656163682873656C662E656C656D656E74732C2066756E6374696F6E286E616D652C20656C656D656E7429207B';
wwv_flow_api.g_varchar2_table(49) := '0A202020202020202020202020656C656D656E742E72656D6F766528293B0A20202020202020207D293B0A202020207D0A0A2020202066756E6374696F6E20636F6D70696C654C6162656C5465787428656C656D656E742C2077696474682C2068656967';
wwv_flow_api.g_varchar2_table(50) := '687429207B0A2020202020202020766172206C6162656C203D20656C656D656E742E7461674E616D652E746F4C6F7765724361736528293B0A202020202020202069662028656C656D656E742E696429207B0A2020202020202020202020206C6162656C';
wwv_flow_api.g_varchar2_table(51) := '202B3D20272327202B20656C656D656E742E69643B0A20202020202020207D0A202020202020202069662028656C656D656E742E636C6173734E616D6529207B0A2020202020202020202020206C6162656C202B3D2028272E27202B206A51756572792E';
wwv_flow_api.g_varchar2_table(52) := '7472696D28656C656D656E742E636C6173734E616D65292E7265706C616365282F202F672C20272E2729292E7265706C616365282F5C2E5C2E2B2F672C20272E27293B0A20202020202020207D0A202020202020202072657475726E206C6162656C202B';
wwv_flow_api.g_varchar2_table(53) := '2027202827202B204D6174682E726F756E6428776964746829202B20277827202B204D6174682E726F756E642868656967687429202B202729273B0A202020207D0A0A2020202066756E6374696F6E206765745363726F6C6C546F702829207B0A202020';
wwv_flow_api.g_varchar2_table(54) := '2020202020696620282173656C662E656C656D656E74732E77696E646F7729207B0A20202020202020202020202073656C662E656C656D656E74732E77696E646F77203D206A51756572792877696E646F77293B0A20202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(55) := '20202072657475726E2073656C662E656C656D656E74732E77696E646F772E7363726F6C6C546F7028293B0A202020207D0A0A2020202066756E6374696F6E207570646174654F75746C696E65506F736974696F6E286529207B0A202020202020202069';
wwv_flow_api.g_varchar2_table(56) := '6628652E7479706520213D2027726573697A6527297B0A2020202020202020202069662028652E7461726765742E636C6173734E616D6520262620652E7461726765742E636C6173734E616D652E696E6465784F662873656C662E6F7074732E6E616D65';
wwv_flow_api.g_varchar2_table(57) := '73706163652920213D3D202D3129207B0A202020202020202020202020202072657475726E3B0A202020202020202020207D0A202020202020202020206966202873656C662E6F7074732E66696C74657229207B0A202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(58) := '662028216A517565727928652E746172676574292E69732873656C662E6F7074732E66696C7465722929207B0A20202020202020202020202020202020202072657475726E3B0A20202020202020202020202020207D0A202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(59) := '2020202020202020207075622E656C656D656E74203D20652E7461726765740A20202020202020207D20656C7365207B0A20202020202020202020696628217075622E656C656D656E74292072657475726E3B0A20202020202020207D0A202020202020';
wwv_flow_api.g_varchar2_table(60) := '0A20202020202020206966282173656C662E6F7074732E686964654C6162656C29200A202020202020202020206A517565727928272E27202B2073656C662E6F7074732E6E616D657370616365202B20275F6C6162656C27292E72656D6F7665436C6173';
wwv_flow_api.g_varchar2_table(61) := '73282768696464656E27293B0A0A20202020202020207661722062203D2073656C662E6F7074732E626F7264657257696474683B0A2020202020202020766172207363726F6C6C5F746F70203D206765745363726F6C6C546F7028293B0A202020202020';
wwv_flow_api.g_varchar2_table(62) := '202076617220706F73203D207075622E656C656D656E742E676574426F756E64696E67436C69656E745265637428293B0A202020202020202076617220746F70203D20706F732E746F70202B207363726F6C6C5F746F703B0A2020202020202020766172';
wwv_flow_api.g_varchar2_table(63) := '206C6162656C5F74657874203D20636F6D70696C654C6162656C54657874287075622E656C656D656E742C20706F732E77696474682C20706F732E686569676874293B0A20202020202020207075622E656C656D656E742E6C6162656C203D206C616265';
wwv_flow_api.g_varchar2_table(64) := '6C5F746578743B0A20202020202020202F2F2066696C6C20636F6E74656E740A20202020202020206966202873656C662E6F7074732E66696C6C436F6E74656E7429207B0A20202020202020202020242827626F647927292E66696E6428272E27202B20';
wwv_flow_api.g_varchar2_table(65) := '73656C662E6F7074732E6E616D657370616365202B20275F66696C6C5F636F6E74656E7427292E72656D6F7665436C6173732873656C662E6F7074732E6E616D657370616365202B20275F66696C6C5F636F6E74656E7427293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(66) := '2024287075622E656C656D656E74292E616464436C6173732873656C662E6F7074732E6E616D657370616365202B20275F66696C6C5F636F6E74656E7427293B0A2020202020202020202024287075622E656C656D656E74292E66696E6428272A27292E';
wwv_flow_api.g_varchar2_table(67) := '616464436C6173732873656C662E6F7074732E6E616D657370616365202B20275F66696C6C5F636F6E74656E7427293B0A20202020202020207D0A20202020202020200A2020202020202020766172206C6162656C5F746F70203D204D6174682E6D6178';
wwv_flow_api.g_varchar2_table(68) := '28302C20746F70202D203230202D20622C207363726F6C6C5F746F70293B0A2020202020202020766172206C6162656C5F6C656674203D204D6174682E6D617828302C20706F732E6C656674202D2062293B0A0A202020202020202073656C662E656C65';
wwv_flow_api.g_varchar2_table(69) := '6D656E74732E6C6162656C2E637373287B20746F703A206C6162656C5F746F702C206C6566743A206C6162656C5F6C656674207D292E74657874286C6162656C5F74657874293B0A202020202020202073656C662E656C656D656E74732E746F702E6373';
wwv_flow_api.g_varchar2_table(70) := '73287B20746F703A204D6174682E6D617828302C20746F70202D2062292C206C6566743A20706F732E6C656674202D20622C2077696474683A20706F732E7769647468202B20622C206865696768743A2062207D293B0A202020202020202073656C662E';
wwv_flow_api.g_varchar2_table(71) := '656C656D656E74732E626F74746F6D2E637373287B20746F703A20746F70202B20706F732E6865696768742C206C6566743A20706F732E6C656674202D20622C2077696474683A20706F732E7769647468202B20622C206865696768743A2062207D293B';
wwv_flow_api.g_varchar2_table(72) := '0A202020202020202073656C662E656C656D656E74732E6C6566742E637373287B20746F703A20746F70202D20622C206C6566743A204D6174682E6D617828302C20706F732E6C656674202D2062292C2077696474683A20622C206865696768743A2070';
wwv_flow_api.g_varchar2_table(73) := '6F732E686569676874202B2062207D293B0A202020202020202073656C662E656C656D656E74732E72696768742E637373287B20746F703A20746F70202D20622C206C6566743A20706F732E6C656674202B20706F732E77696474682C2077696474683A';
wwv_flow_api.g_varchar2_table(74) := '20622C206865696768743A20706F732E686569676874202B202862202A203229207D293B0A202020207D0A0A2020202066756E6374696F6E2073746F704F6E457363617065286529207B0A202020202020202069662028652E6B6579436F6465203D3D3D';
wwv_flow_api.g_varchar2_table(75) := '2073656C662E6B6579436F6465732E455343207C7C20652E6B6579436F6465203D3D3D2073656C662E6B6579436F6465732E4241434B5350414345207C7C20652E6B6579436F6465203D3D3D2073656C662E6B6579436F6465732E44454C45544529207B';
wwv_flow_api.g_varchar2_table(76) := '0A2020202020202020202020207075622E73746F7028293B0A20202020202020207D0A0A202020202020202072657475726E2066616C73653B0A202020207D0A0A2020202066756E6374696F6E20636C69636B48616E646C6572286529207B0A20202020';
wwv_flow_api.g_varchar2_table(77) := '202020207075622E73746F7028293B0A202020202020202073656C662E6F7074732E6F6E436C69636B287075622E656C656D656E74293B0A0A202020202020202072657475726E2066616C73653B0A202020207D0A0A202020207075622E737461727420';
wwv_flow_api.g_varchar2_table(78) := '3D2066756E6374696F6E202829207B0A2020202020202020696E69745374796C65736865657428293B0A20202020202020206966202873656C662E61637469766520213D3D207472756529207B0A20202020202020202020202073656C662E6163746976';
wwv_flow_api.g_varchar2_table(79) := '65203D20747275653B0A2020202020202020202020206372656174654F75746C696E65456C656D656E747328293B0A2020202020202020202020206A51756572792827626F647927292E6F6E28276D6F7573656D6F76652E27202B2073656C662E6F7074';
wwv_flow_api.g_varchar2_table(80) := '732E6E616D6573706163652C207570646174654F75746C696E65506F736974696F6E293B0A2020202020202020202020206A51756572792827626F647927292E6F6E28276B657975702E27202B2073656C662E6F7074732E6E616D6573706163652C2073';
wwv_flow_api.g_varchar2_table(81) := '746F704F6E457363617065293B0A2020202020202020202020206966202873656C662E6F7074732E6F6E436C69636B29207B0A2020202020202020202020202020202073657454696D656F75742866756E6374696F6E202829207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(82) := '2020202020202020202020206A51756572792827626F647927292E6F6E2827636C69636B2E27202B2073656C662E6F7074732E6E616D6573706163652C2066756E6374696F6E2865297B0A20202020202020202020202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(83) := '66202873656C662E6F7074732E66696C74657229207B0A2020202020202020202020202020202020202020202020202020202069662028216A517565727928652E746172676574292E69732873656C662E6F7074732E66696C7465722929207B0A202020';
wwv_flow_api.g_varchar2_table(84) := '202020202020202020202020202020202020202020202020202020202072657475726E2066616C73653B0A202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(85) := '2020202020202020202020202020202020202020202020636C69636B48616E646C65722E63616C6C28746869732C2065293B0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D2C203530293B0A20';
wwv_flow_api.g_varchar2_table(86) := '20202020202020202020207D0A20202020202020207D0A202020207D3B0A0A202020207075622E73746F70203D2066756E6374696F6E202829207B0A202020202020202073656C662E616374697665203D2066616C73653B0A202020202020202072656D';
wwv_flow_api.g_varchar2_table(87) := '6F76654F75746C696E65456C656D656E747328293B0A20202020202020206966202873656C662E6F7074732E66696C6C436F6E74656E7429207B0A202020202020202020242827626F647927292E66696E6428272E27202B2073656C662E6F7074732E6E';
wwv_flow_api.g_varchar2_table(88) := '616D657370616365202B20275F66696C6C5F636F6E74656E7427292E72656D6F7665436C6173732873656C662E6F7074732E6E616D657370616365202B20275F66696C6C5F636F6E74656E7427293B0A20202020202020207D0A20202020202020206A51';
wwv_flow_api.g_varchar2_table(89) := '756572792827626F647927292E6F666628276D6F7573656D6F76652E27202B2073656C662E6F7074732E6E616D657370616365290A2020202020202020202020202E6F666628276B657975702E27202B2073656C662E6F7074732E6E616D657370616365';
wwv_flow_api.g_varchar2_table(90) := '290A2020202020202020202020202E6F66662827636C69636B2E27202B2073656C662E6F7074732E6E616D657370616365293B0A202020207D3B0A0A2020202072657475726E207075623B0A7D3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(21774245011525627884)
,p_plugin_id=>wwv_flow_api.id(20905356408423373797)
,p_file_name=>'jquery.dom-outline-1.0.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
