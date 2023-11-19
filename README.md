# React App Stater

This is react-app project starter.

 - [React](https://react.dev/)
 - [Emotion styles](https://emotion.sh/docs/introduction)
 - [React router dom](https://reactrouter.com/en/main) 
 - [Vite](https://vitejs.dev/) 
 - [Typesript](https://www.typescriptlang.org/) 


# Handful scripts

## Create a page

```
   npm run create-page /Folder/PageName # Notes: PageName must be in Pascal case
```

This script will create a page component under `pages` folder, a loader under `loaders` folder and an actions under `actions` folder.

## Update routes 

```
   npm run update-routes
```

This script will lookup page components in `pages` folder and update `routes.tsx` file.

## Update icons

```
   npm run update-icons
```

This script will lookup all svg files under in folder `assets/svgs` and automatically create an icon component for them.