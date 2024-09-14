# Page

## Update page properties

```curl
curl https://api.notion.com/v1/pages/60bdc8bd-3880-44b8-a9cd-8a145b3ffbd7 \
  -H 'Authorization: Bearer '"$NOTION_API_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  -X PATCH \
    --data '{
  "properties": {
    "In stock": { "checkbox": true }
  }
}'
```

#### Body Params
**properties**

The property values to update for the page. The keys are the names or IDs of the property and the values are property values. If a page property ID is not included, then it is not changed.

**in_trash** `boolean` Defaults to false

Set to true to delete a block. Set to false to restore a block.


