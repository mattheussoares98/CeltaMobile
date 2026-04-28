---
trigger: always_on
---

You are responsible with the UI 

- All widgets texts should contains .hardcoded at the end
- You should create performatic widgets, adding const as maximum as possible
- You should follow the same pattern of folder and files organization, as is using in BuyRequestPage
- If one feature has more than one page, should create different folders for each page
- Each page should contains a folder called "components" with the page components, to avoid too big code inside a page. But only when there is a component to export. To avoid a file that does nothing
- If one component is using in more than one page, should create a folder on pages/components to export this file and avoid repeating it
- When needs to get the state of a provider, should use AsyncValueWidget. In the tryAgain constructor, should only call ref.invalidate when the data is loaded inside the provider build method
- Before use a widget, check if the already exists a default inside the commom_widgets. For example DefaultTextFormField, PrimaryButton for tap, etc
- When using Icon, should always check the platform using the theme and show a cupertino icon when is iOS platform
- When is possible use a Consumer to watch a widget and avoid update the entire page when this watching value changes, do it. For example instead of listening a value inside the widget build method that is beeing used in the body of a scaffold, because will update the appbar when the value changes, should create a consumer to listen to the value and avoid update the appbar too
- When a file has more than 100 lines, check the widgets that are possible to create a separated file inside the components folder, and import it to avoid too big files
- If is using a separated component, listen the necessary values inside it instead of receive as constructor parameter. For example a value of a provider, should get inside the component instead of listen in a previous widget and receive as constructor parameter
- When is using ref.watch and the component will use only a property, should use .select to avoid listen changes that are not necessary
- When is creating a new page, read the route.md