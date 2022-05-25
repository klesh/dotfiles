# Office365

## Outlook MFA

- Change authentication method to __OAuth2__ and you are good to go


# Calendar

- tbsync
- provider for caldav & carddav: for nextcloud synchronization
- provider for exchange activesync: for outlook synchronization

# Holiday Calendar

Create new calendar -> On the Network

1. [canada holidy](https://www.officeholidays.com/subscribe/canada)
2. [chinese holiday](https://www.officeholidays.com/subscribe/china)


# Style

- Plain Text mail font too small: Preferences > Fonts > Advanced > set Font size for both `Latin` and `Other writing systems`
- Enable `userChrome.css`: 
  1. Preferences
  2. scroll to bottom find Config Editor
  3. search 'toolkit.legacyUserProfileCustomizations.stylesheets', set it to true
- Make top message of thread bold
  1. Menu > Help > More trouble shooting information
  2. Profile Directory > Open Directory
  3. Shutdown thunderbird
  4. Create file 'chrome/userChrome.css' with following content:
  ```
    /*
     * Do not remove the @namespace line -- it's required for correct functioning
     */

    @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

    /* set default namespace to XUL */

    /*
     * Collapsed read thread, but the thread contains unread , set text to bod black 
     */
    treechildren::-moz-tree-cell-text(container, closed, hasUnread, read) {
        text-decoration: none !important;
        font-weight:  bold !important;
        color: #000000 !important;
    }

    /*
     * If thread selected, revert to highlight text color
     */
    treechildren::-moz-tree-cell-text(container, closed, hasUnread, read, focus, selected),
       treechildren::-moz-tree-cell-text(container, hasUnread, read, focus, selected) {
        color: HighlightText !important;
    }
  ```
